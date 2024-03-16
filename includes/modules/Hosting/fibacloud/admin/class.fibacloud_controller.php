<?php

class fibacloud_Controller extends HBController {
    public $module;
    public function beforeCall($params){}
    
    public function accountdetails($params){
        $typetemplates = [];
        $typetemplates["adminaccounts"]["details"]["replace"] = APPDIR_MODULES . $this->module->getModuleType() . DS . strtolower($this->module->getModuleName()) . DS . "templates" . DS . "adminarea" . DS . "account.tpl";
        $this->adminareatpl = $typetemplates["adminaccounts"]["details"]["replace"];
        $this->template->assign("typetemplates", $typetemplates);
        $this->template->assign("moduletpldir", APPDIR_MODULES . $this->module->getModuleType() . DS . strtolower($this->module->getModuleName()) . DS . "templates" . DS . "adminarea" . DS);
        if (isset($params["vpsdo"]) && is_callable([$this, "vps_" . $params["vpsdo"]])) {
            $this->setupModule($params["id"]);
            $this->{"vps_" . $params["vpsdo"]}($params);
            $this->template->assign("vpsdo", $params["vpsdo"]);
        }
    }
    
    private function vps_clientsvms($params){
        $vm = $this->module->GetVmDetails();
        $this->template->assign("vm", empty($vm) ? false : $vm);
        $this->template->assign("moduleid", $this->module->getModuleId());
        $this->template->showtpl = $this->adminareatpl;
    }
    
    protected function vps_shutdown($params){
        if ($this->module->ShutDown()) {
            Engine::addInfo("Server stopped");
        }
    }
    
    protected function vps_stop($params){
        if ($this->module->PowerOff()) {
            Engine::addInfo("Server stopped");
        }
    }
    
    protected function vps_startup($params){
        if ($this->module->PowerON()) {
            Engine::addInfo("Server started");
        }
    }
    
    protected function vps_reboot($params){
        if ($this->module->Reboot()) {
            Engine::addInfo("Server rebooted");
        }
    }
    
    protected function vps_reset($params){
        if ($this->module->Reset()) {
            Engine::addInfo("Server restarted");
        }
    }
    
    protected function setupModule($service){
        $a = HBLoader::LoadModel("Accounts");
        $data = $a->getAccount($service);
        $account_config = [];
        $account_config = $a->getAccountModuleConfig($service);
        $s = HBLoader::LoadModel("Servers");
        $servdata = $s->getServerDetails($data["server_id"]);
        $this->module->connect($servdata);
        $this->module->setAccountConfig($account_config);
        $this->module->setAccount($data);
        $this->module->addUser($data["username"], $data["password"], Utilities::getClientEmail($data["client_id"]));
    }
    
    public function productdetails($params){
        $this->template->assign("module_templates", APPDIR_MODULES . $this->module->getModuleType() . DS . strtolower($this->module->getModuleName()) . DS . "templates" . DS . "adminarea" . DS);
        if (isset($params["server_id"])) {
            $s = HBLoader::LoadModel("Servers");
            $this->module->connect($s->getServerDetails($params["server_id"]));
        }
    }
}
?>
