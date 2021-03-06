<?php

defined('BASEPATH') OR exit('No direct script access allowed');

$url = rtrim(__DIR__, 'controllers');
require_once $url . 'classes/user.php';

class Subscribe extends CI_Controller {

    private $data;
    private $db_drivers;

    function __construct() {
        parent::__construct();
        // loading models
        $this->load->model('subscribeFormMod');
        $this->data = NULL;
        $this->db_drivers = array('mysqli');
    }
    
    private function testConnection($drivers, $config){
        $driver = '';
        if($drivers){
            $driver = $drivers[0];
            $config['dbdriver'] = $driver;
            $db = @$this->load->database($config, TRUE);
            if($db->conn_id) {
                return $driver;
            } else {
                array_shift($drivers);
                $driver = $this->testConnection($drivers, $config);
            }
        }
        return $driver;
    }
    
    private function testConnectionWithDriver($config){
        $db = @$this->load->database($config, TRUE);
        if($db->conn_id) {
            return true;
        }
        return false;
    }
    
    public function connect($config, $companyId){
        $status = false;
        if($config['dbdriver']){
            $status = $this->testConnectionWithDriver($config);
        } else {
            $db_driver = $this->testConnection($this->db_drivers, $config);
            if($db_driver){
                $status = true;
                $data = array("db_driver" => $db_driver);
                $this->subscribeFormMod->updateCompanyDbDriver($data, $companyId);
            }
        }
        return $status;
    }

    public function index() {
        $data['title'] = 'Subscribe ChatBot';
        $data['package_id'] = '1';
        $data['platforms'] = $this->subscribeFormMod->loadPlatforms();
        $data['websiteTypes'] = $this->subscribeFormMod->loadWebsiteTypes();

        $this->load->view('header', $data);
        $this->load->view('subscribeForm', $data);
        $this->load->view('footer');
    }
    
    public function submitSubscription()
    {
        $config = array(
            "hostname" => $this->input->post('server'),
            "username" => $this->input->post('username'),
            "password" => $this->input->post('password'),
            "database" => $this->input->post('DB_name'),
            "dbdriver" => "",
            "db_debug" => false
        );
        //$db_driver = $this->testConnection($this->db_drivers, $config);
        $db_driver = 'mysql';
        $db_verified = 1;
        /*$db_verified = 0;
        if($db_driver){
            $db_verified = 1;
        }*/
        
        $data_client = array(
            'name' => $this->input->post('name'),
            'password' => md5($this->input->post('cpassword')),
            'email'  => $this->input->post('email'),
            'phone'  => $this->input->post('phone')
        );
        
        $insert_id = $this->subscribeFormMod->addClient($data_client);
        $need_support = 0;
        // Platform is native
        if($this->input->post('platform') == 5){
            $need_support = 1;
        }
        
        // The next id for company
        $new_company_id = $this->subscribeFormMod->getLastComapnyId() + 1;
        
        $token = password_hash($insert_id . $this->input->post('company') . $this->input->post('bot_name') , PASSWORD_DEFAULT);
        //$this->load->library('encrypt');
        // Encrypt bot name
        //$bot_name = $this->encrypt->encode($this->input->post('bot_name') . "_" . $new_company_id);
        $bot_name = $this->input->post('company') . "_" . $new_company_id;
        $data_company= array(
            'client_id' => $insert_id,
            'name'  => $this->input->post('company'),
            /*'db_server'  => $this->input->post('server'),
            'db_name'  => $this->input->post('DB_name'),
            'db_username'  => $this->input->post('username'),
            'db_password'  => $this->input->post('password'),*/
            'db_server'  => '',
            'db_name'  => '',
            'db_username'  => '',
            'db_password'  => '',
            'db_driver'  => $db_driver,
            'platform_id'  => $this->input->post('platform'),
            'domain'  => $this->input->post('domain'),
            'type_id'  => $this->input->post('website_type'),
            'support'  => $need_support,
            'bot_name'  => $bot_name,
            'token'  => $token,
            'db_verified'  => $db_verified,
            'status'  => 'pending',
            'first_train'  => '1'
        );
        
        $this->subscribeFormMod->addCompany($data_company);
        
        $data_subscriptions= array(
            'client_id' => $insert_id,
            'package_id'  => $this->input->post('package_id'),
            'from_date'  => date("m/d/Y", time()),
            'payment_id'  => '',
            'payment_status'  => 'pending',
            'status'  => 'pending'
        ); 
    
        $insert_id = $this->subscribeFormMod->addSubscription($data_subscriptions);
        $this->sendFirstStepEmail($data_client['email'], $data_client['name'], $token);
        $data['order_id']=$insert_id;
        $data['description_order']='Bot chat';
        $data['price']=50;
        $data['currency']='USD';
        $this->load->view('paymentGetaway', $data);
    }
    
    public function validateDomain() {
                echo 'yes';exit;
        $url_http = 'http://'. $_POST['domain'].'/';
        $url_https= 'https://'. $_POST['domain'].'/';
        $ch = curl_init($url_http);
        curl_setopt($ch, CURLOPT_TIMEOUT, 5);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $data = curl_exec($ch);
        $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch); 
        if($httpcode>=200 && $httpcode<300){
            echo 'yes';
        } else {
            $ch = curl_init($url_https);
            curl_setopt($ch, CURLOPT_TIMEOUT, 5);
            curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            $data = curl_exec($ch);
            $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            curl_close($ch); 
            if($httpcode>=200 && $httpcode<300){
                echo 'yes';
            }else{
                echo 'no';
            }
        }
    }

    public function successOrder()
    {
        if (isset($_POST['transaction_id']) && isset($_POST['status']) && isset($_POST['order_id']))
        {
            if($_POST['status']=='success')
            {
                $this->session->set_flashdata('payment_status', 'success');

                    $subscripe_data = array(
                        'payment_status' => 'success'
                    );
                
                    $this->subscribeFormMod->UpdateSubscripe($subscripe_data,$_POST['order_id']);
            }
            else
            {
                $this->session->set_flashdata('payment_status', 'failed');

                    $subscripe_data = array(
                        'payment_status' => 'failed'
                    );
                
                    $this->subscribeFormMod->UpdateSubscripe($subscripe_data,$_POST['order_id']);
            }
        }
        redirect(base_url());
    }
    
    private function sendEmail ($subject, $body, $to){
        $this->load->library('email');
        // Also, for getting full html you may use the following internal method:
        //$body = $this->email->full_html($subject, $message);

        $result = $this->email
            ->from('optimal.bot.service@gmail.com', 'Optimal AI Support')
            ->to($to)
            ->subject($subject)
            ->message($body)
            ->send();
    }
    
    public function sendFirstStepEmail($email, $username, $token){
        $info = array("username" => $username, "email" => $email, "token" => $token);
        $data = $this->load->view('emailTemplates/registeration_complete', $info, TRUE);
        $this->sendEmail('Welcome to Optimal Bot', $data, $email);
    } 
    
    public function downloadScript($bot_name){
        $this->load->helper('download');
        $company = $this->subscribeFormMod->getCompanyByBotName($bot_name);
        $file = '<meta name="optimal-bot-verification" content="' . $company->token . '" />
<?php

function connect($host, $username, $password, $DBName){
    $conn = new mysqli($host, $username, $password, $DBName);
    // Check connection
    if (!$conn->connect_error) {
        return "mysqli";
    }

    $conn = pg_connect("host=$host dbname=$DBName user=$username password=$password");
    // Check connection
    if ($conn->connect_error) {
        return "postgresql";
    }

    return "";
}

$driver = connect("localhost", "' . $company->db_username . '", "' . $company->db_password . '", "' . $company->db_name . '");
?>
<script src="https://code.jquery.com/jquery-3.4.1.min.js" type="text/javascript"></script>
<script>
    $(document).ready(function() {
        var driver = "<?= $driver ?>";
        var param = JSON.stringify({
            name: "validateDatabase",
            param: {driver: driver}
        });
        var token = document.querySelector("meta[name=optimal-bot-verification]").getAttribute("content");
        $.ajax({
            type: "POST",
            url: "https://207.180.195.64:5002/",
            data: param,
            headers: {
                "Authorization": "Bearer " + token,
                "Content-Type":"application/json",
            },
            success: function(data) {
                if("error" in data){
                    document.write(data.error.message);
                    return;
                }
                if (data.response.result.status == "success") {
                    document.write("Success, Database verified successfully, Thank you!");
                } else {
                    document.write("You have already verified the db.");
                }
            }
        });
    });

</script>
';
        $name = 'db_verification.php';
        force_download($name, $file);
    }

}
