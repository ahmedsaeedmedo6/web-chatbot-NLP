import chatterbot.chatterbot as chatterbot
import re
from DataCleaning import DataCleaning


class chatBot(chatterbot.ChatBot):
    """
    Override  chatterbot class
    """

    def __init__(self, name, **kwargs):
        super().__init__(name, **kwargs)

    def get_response(self, statement=None, **kwargs):
        """
        Return the bot's response based on the input.

        :param statement: An statement object or string.
        :returns: A response to the input.
        :rtype: Statement

        :param additional_response_selection_parameters: Parameters to pass to the
            chat bot's logic adapters to control response selection.
        :type additional_response_selection_parameters: dict

        :param persist_values_to_response: Values that should be saved to the response
            that the chat bot generates.
        :type persist_values_to_response: dict
        """
        Statement = self.storage.get_object('statement')

        additional_response_selection_parameters = kwargs.pop('additional_response_selection_parameters', {})

        persist_values_to_response = kwargs.pop('persist_values_to_response', {})

        if isinstance(statement, str):
            kwargs['text'] = statement

        if isinstance(statement, dict):
            kwargs.update(statement)

        if statement is None and 'text' not in kwargs:
            raise self.ChatBotException(
                'Either a statement object or a "text" keyword '
                'argument is required. Neither was provided.'
            )

        if hasattr(statement, 'serialize'):
            kwargs.update(**statement.serialize())

        tags = kwargs.pop('tags', [])

        text = kwargs.pop('text')

        input_statement = Statement(text=text, **kwargs)

        input_statement.add_tags(*tags)

        # Preprocess the input statement
        for preprocessor in self.preprocessors:
            input_statement = preprocessor(input_statement)

        # Make sure the input statement has its search text saved

        if not input_statement.search_text:
            input_statement.search_text = self.storage.tagger.get_bigram_pair_string(input_statement.text)

        if not input_statement.search_in_response_to and input_statement.in_response_to:
            input_statement.search_in_response_to = self.storage.tagger.get_bigram_pair_string(input_statement.in_response_to)

        response, Story_ID ,children_questions,means_questions = self.generate_response(input_statement, additional_response_selection_parameters)

        # Update any response data that needs to be changed
        if persist_values_to_response:
            for response_key in persist_values_to_response:
                response_value = persist_values_to_response[response_key]
                if response_key == 'tags':
                    input_statement.add_tags(*response_value)
                    response.add_tags(*response_value)
                else:
                    setattr(input_statement, response_key, response_value)
                    setattr(response, response_key, response_value)

        if not self.read_only:
            self.learn_response(input_statement)

            # Save the response generated for the input
            res = response.serialize()
            # Filter User Query
            dt = DataCleaning()
            res['text'] = dt.clean(res['text'])
            self.storage.create(**res)

        return response, Story_ID ,children_questions,means_questions

    def generate_response(self, input_statement, additional_response_selection_parameters=None):
        """
        Return a response based on a given input statement.

        :param input_statement: The input statement to be processed.
        """
        Statement = self.storage.get_object('statement')

        results = []
        result = None
        max_confidence = -1

        for adapter in self.logic_adapters:
            if adapter.can_process(input_statement):

                output, Story_ID ,children_questions,means_questions = adapter.process(input_statement, additional_response_selection_parameters)
                results.append(output)

                self.logger.info(
                    '{} selected "{}" as a response with a confidence of {}'.format(
                        adapter.class_name, output.text, output.confidence
                    )
                )

                if output.confidence > max_confidence:
                    result = output
                    max_confidence = output.confidence
            else:
                self.logger.info(
                    'Not processing the statement using {}'.format(adapter.class_name)
                )

        class ResultOption:
            def __init__(self, statement, count=1):
                self.statement = statement
                self.count = count

        # If multiple adapters agree on the same statement,
        # then that statement is more likely to be the correct response
        if len(results) >= 3:
            result_options = {}
            for result_option in results:
                result_string = result_option.text + ':' + (result_option.in_response_to or '')

                if result_string in result_options:
                    result_options[result_string].count += 1
                    if result_options[result_string].statement.confidence < result_option.confidence:
                        result_options[result_string].statement = result_option
                else:
                    result_options[result_string] = ResultOption(
                        result_option
                    )

            most_common = list(result_options.values())[0]

            for result_option in result_options.values():
                if result_option.count > most_common.count:
                    most_common = result_option

            if most_common.count > 1:
                result = most_common.statement

        response = Statement(
            text=result.text,
            in_response_to=input_statement.text,
            conversation=input_statement.conversation,
            persona='bot:' + self.name
        )

        response.confidence = result.confidence

        return response, Story_ID ,children_questions,means_questions

    def learn_response(self, statement, previous_statement=None):
        """
        Learn that the statement provided is a valid response.
        """
        if not previous_statement:
            previous_statement = statement.in_response_to

        if not previous_statement:
            previous_statement = self.get_latest_response(statement.conversation)
            if previous_statement:
                previous_statement = previous_statement.text

        previous_statement_text = previous_statement

        if not isinstance(previous_statement, (str, type(None), )):
            statement.in_response_to = previous_statement.text
        elif isinstance(previous_statement, str):
            statement.in_response_to = previous_statement

        self.logger.info('Adding "{}" as a response to "{}"'.format(
            statement.text,
            previous_statement_text
        ))

        # Save the input statement
        return self.storage.create(**statement.serialize())

    def getAccuracyOfQuestions(self, statement=None, **kwargs):

        Statement = self.storage.get_object('statement')

        if isinstance(statement, str):
            kwargs['text'] = statement

        if isinstance(statement, dict):
            kwargs.update(statement)

        if statement is None and 'text' not in kwargs:
            raise self.ChatBotException(
                'Either a statement object or a "text" keyword '
                'argument is required. Neither was provided.'
            )

        if hasattr(statement, 'serialize'):
            kwargs.update(**statement.serialize())

        tags = kwargs.pop('tags', [])

        text = kwargs.pop('text')

        input_statement = Statement(text=text, **kwargs)

        input_statement.add_tags(*tags)

        # Preprocess the input statement
        for preprocessor in self.preprocessors:
            input_statement = preprocessor(input_statement)


        for adapter in self.logic_adapters:
            if adapter.can_process(input_statement):
                FAQ_simarities = adapter.getAccuracyOfQuestions(input_statement)

        return FAQ_simarities

