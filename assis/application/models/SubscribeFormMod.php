<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

class subscribeFormMod extends CI_Model {

    public function loadPlatforms() {
        $query = $this->db->get('platform');
        $platforms=array();
        $i=0;
        foreach ($query->result() as $row)
        {
            $platforms[]=$row;
        }
        return $platforms;
    }

    public function loadWebsiteTypes() {
        $query = $this->db->get('website_type');
        $website_types=array();
        $i=0;
        foreach ($query->result() as $row)
        {
            $website_types[]=$row;
        }
        return $website_types;
    }

    

}