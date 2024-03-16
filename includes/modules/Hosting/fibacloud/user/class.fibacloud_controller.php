<?php

class fibacloud_Controller extends HBController {
    public $module;
    protected $section;
    private $account_id = 0;
    public function accountdetails($params)
    {
        $this->template->assign("commontpl", MAINDIR . "templates" . DS . "common" . DS . "cloudhosting" . DS);
        $this->template->assign("commondir", MAINDIR . "templates" . DS . "common" . DS . "cloudhosting" . DS);
        $this->clientareapath = APPDIR_MODULES . $this->module->getModuleType() . DS . strtolower($this->module->getModuleName()) . DS . "templates" . DS . "clientarea" . DS;
        $this->template->assign("onappdir", $this->clientareapath);
        Engine::singleton()->getObject("language")->addTranslation("onapp");
        $extra = $params["account"];
        $this->account_id = $extra["id"];
        $instance = $this->module->GetVmDetails();
        if ($extra["status"] == "Active" && $params["vpsdo"] != "billing" && $instance) {
            $this->setupModule($params["service"]);
            try {
                if (is_callable([$this, "singlevm_" . $params["vpsdo"]])) {
                    $this->{"singlevm_" . $params["vpsdo"]}($params);
                } else {
                    $this->singlevm_default($params);
                }
            } catch (Exception $e) {
            }
            $this->template->assign("o_sections", ["o_rebuild" => true, "o_reboot" => true, "o_startstop" => true]);
        } else {
            $this->billing($params);
        }
        $this->template->assign("provisioning_type", $params["account"]["options"]["type"] == "multi" ? "cloud" : ($params["account"]["options"]["type"] == "reseller" ? "reseller" : "single"));
        $this->template->assign("vpsdo", isset($params["vpsdo"]) ? Registrator::paranoid($params["vpsdo"]) : false);
        $this->template->assign("vpsid", isset($params["vpsid"]) ? Registrator::paranoid($params["vpsid"]) : false);
        $this->section = empty($this->section) ? "vmdetails" : $this->section;
        $this->template->showtpl = $this->clientareapath . $this->section;
        $this->template->assign("vmsection", $this->section);
    }
    
    protected function billing(&$params) {
        $params["vpsdo"] = "billing";
        $this->section = "billing";
    }
    
    protected function singlevm_shutdown($params) {
        {$this->module->ShutDown();}
        Utilities::redirect("?cmd=clientarea&action=services&service=" . $params["service"]);
    }
    
    protected function singlevm_poweroff($params) {
        {$this->module->PowerOff();}
        Utilities::redirect("?cmd=clientarea&action=services&service=" . $params["service"]);
    }
    
    protected function singlevm_startup($params){
        {$this->module->PowerON();}
        Utilities::redirect("?cmd=clientarea&action=services&service=" . $params["service"]);
    }
    
    protected function singlevm_reboot($params){
        {$this->module->Reboot();}
        Utilities::redirect("?cmd=clientarea&action=services&service=" . $params["service"]);
    }
    
    protected function singlevm_reset($params){
        {$this->module->Reset();}
        Utilities::redirect("?cmd=clientarea&action=services&service=" . $params["service"]);
    }
    
    protected function singlevm_reinstall($params){
        $this->section = "vmdetails";
        if ($params["changeos"]) {
            if ($this->module->Reinstall($params)) {
                HBConfig::storeSetting([], "_fibacloud");
            }
            $c = HBLoader::LoadModel("Clientarea");
            $iid = $c->billForOSTemplate($params["service"], $params["os"], $params["account"]["options"]["type"] == "single");
            if ($iid) {
                Utilities::redirect("?cmd=clientarea&action=invoice&id=" . $iid);
            } else {
                Utilities::redirect("?cmd=clientarea&action=services&service=" . $params["service"]);
            }
        } else {
            $os = $this->module->GetTemplates($params);
            $this->template->assign("ostemplates", $os);
        }
    }
    
    protected function singlevm_upgrade($params){
        $this->section = "vmdetails";
        $c = HBLoader::LoadModel("Clientarea");
        $upg = $c->getServiceUpgrades($params["service"]);
        if ($upg === -1) {
            Engine::addError("upgrade_due_invoice");
            Utilities::redirect("?cmd=clientarea&action=services&service=" . $params["service"]);
        }
        if (empty($upg)) {
            Engine::addError("Its not possible to upgrade this package at this moment. Please contact us to change your resource limits.");
            Utilities::redirect("?cmd=clientarea&action=services&service=" . $params["service"]);
        }
    }
    
    protected function singlevm_default($params){
        $this->section = "vmdetails";
        if (!is_array($vpsinfo)) {
            $vpsinfo = [];
        }
        $vpsinfo = array_merge($vpsinfo, $this->module->GetVmDetails());
        
        if (!$vpsinfo && !$this->module->GetVmDetails()) {
            Utilities::redirect("?cmd=clientarea&action=services&service=" . $params["service"]);
        }
        $this->template->assign("vpsdo", "details");
        if ($params["vpsdo"] == "vmactions") {
            $this->section = "vmactions";
        }
        $vpsinfo["locked"] = $this->prepareLockedStatus($vpsinfo);
        $this->template->assign("vpsdetails", $vpsinfo);
        $this->template->assign("VMDetails", $vpsinfo);
        if (Controller::isAjax() && isset($params["status"])) {
            $this->template->assign("service_id", $params["account"]["id"]);
            $this->template->assign("vpsid", $params["vpsid"]);
            $this->template->display(APPDIR_MODULES . $this->module->getModuleType() . DS . strtolower($this->module->getModuleName()) . DS . "templates" . DS . "clientarea" . DS . "ajax.vmstatus.tpl");
            exit;
        }
    }
    protected function prepareLockedStatus($vps)
    {
        $statuses = ["shutdown", "rebooting", "resetting", "starting", "migrating", "rebuild", "creating", "stopping"];
        if (in_array($vps["status"], $statuses)) {
            return true;
        }
        return false;
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
    
    protected function GetTemplates($params){
        $os = $this->module->GetTemplates();
        $c = HBLoader::LoadModel("Clientarea");
        return $os;
    }
}

?>
