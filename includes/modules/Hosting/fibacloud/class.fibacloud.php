<?php

class fibacloud extends VPSModule {
    protected $version = "1.0.0";
    protected $description = "FibaCloud.com Hostbill VPS Reseller Module";
    protected $serverFields = [
        "hostname" => false, 
        "ip" => false, 
        "maxaccounts" => false, 
        "status_url" => false, 
        "username" => true, 
        "password" => true, 
        "hash" => false, 
        "ssl" => false, 
        "nameservers" => false];
    protected $ajaxLoadValues = false;
    
    protected $options = [
        'ProductID' => [
            'name' => 'Product ID',
            'type' => 'select',
            'default' => [
                '16' => "Shared 1",
                '17' => "Shared 2",
                '21' => "Shared 3",
                '22' => "Shared 4",
                '23' => "Shared 5",
                '24' => "Shared 6",
                '25' => "Shared 7",
                '26' => "Shared 8",
                '49' => "Dedicated 1",
                '50' => "Dedicated 2",
                '51' => "Dedicated 3",
                '52' => "Dedicated 4",
                '53' => "Dedicated 5",
                '54' => "Dedicated 6",
                '55' => "Dedicated 7",
                '56' => "Dedicated 8",
                '57' => "High Memory 1",
                '58' => "High Memory 2",
                '59' => "High Memory 3",
                '60' => "High Memory 4",
            ],
            'description' => 'Please select the product ID.'
        ],
        'Location' => [
            'name' => 'Server Location',
            'type' => 'select',
            'default' => ["EU-CENTRAL-1 | ISTANBUL TR"],
            'description' => 'Please select the Server Location.',
            "value" => false,
            "variable" => "region"
        ],
        "os" => [
            "name" => "OS Template", 
            "value" => false, 
            "variable" => "os"
        ],
        'PromoCode' => [
            'name' => 'Promo Code',
            'type' => 'input',
            'default' => '',
            'description' => 'Enter promo code if applicable.'
        ]
    ];
    protected $details = [
    "option4" => [
        "name" => "domain",
        "value" => false,
        "type" => "input",
        "default" => false
    ],
    "option1" => [
        "name" => "username",
        "value" => false,
        "type" => "input",
        "default" => false
    ],
    "option2" => [
        "name" => "password",
        "value" => false,
        "type" => "input",
        "default" => false
    ],
    "option5" => [
        "name" => "rootpassword",
        "value" => false,
        "type" => "input",
        "default" => false
    ],
    "option15" => [
        "name" => "orderid",
        "value" => false,
        "type" => "input",
        "default" => false
    ],
    "option16" => [
        "name" => "vmid",
        "value" => false,
        "type" => "input",
        "default" => false
    ]
];

    private $username;
    private $password;

    function __construct(){
        parent::__construct();
    }
	
	public function connect($connect){
    $this->username = $connect["username"];
    $this->password = $connect["password"];
	}
    
    public function testConnection() {
    $url = "https://cloud.fibacloud.com/api/login";
    $username = $this->username;
    $password = $this->password;

    $postData = http_build_query([
        'username' => $username,
        'password' => $password
    ]);

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);

    $response = curl_exec($ch);
    $httpStatusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($httpStatusCode == 200) {
        $responseArray = json_decode($response, true);
        if (isset($responseArray['token'])) {
            return true;
        } else {
            $this->addInfo("Failed to retrieve token. API Response: " . $response);
            return false;
        }
       } else {
        $this->addInfo("Failed to connect. HTTP Status Code: " . $httpStatusCode . ". Response: " . $response);
        return false;
       }
    }
    
    public function callAPI($method, $url, $username, $password, $data = []) {
        $curl = curl_init();
        
        switch ($method) {
        case "POST":
            curl_setopt($curl, CURLOPT_POST, true);
            if (!empty($data)) {
                curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($data));
            }
            break;
        case "GET":
            if (!empty($data)) {
                $url .= '?' . http_build_query($data);
            }
            break;
        case "PUT":
            curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "PUT");
            if (!empty($data)) {
                curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($data));
            }
            break;
        case "DELETE":
            curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "DELETE");
            break;
        }

        curl_setopt($curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
        curl_setopt($curl, CURLOPT_USERPWD, $username . ":" . $password);
        curl_setopt($curl, CURLOPT_URL, $this->apiUrl . $url);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
        ]);

        $response = curl_exec($curl);
        $error = curl_error($curl);
        curl_close($curl);

        if ($error) {
            $this->addInfo("API call to $url failed: $error");
        } else {
            return json_decode($response, true);
        }
    }
    
    private function getProductIdFromName($packageName) {
       foreach ($this->options['ProductID']['default'] as $id => $name) {
        if ($name === $packageName) {
            return $id;
        }
       }
      return null;
    }
    
    public function Create() {
    try {
        $apiUrl = 'https://cloud.fibacloud.com/api';
        $username = $this->username;
        $password = $this->password;
        
        $packageName = $this->options["ProductID"]["value"];

        $productId = $this->getProductIdFromName($packageName);
        if ($productId === null) {
            $this->addError("Paket adına karşılık gelen bir ID bulunamadı: {$packageName}");
            return false;
        }
        
        $promocode = $this->options["PromoCode"]["value"];
        $hostname = $this->account_details['domain'];
        $selectedOsName = $this->resource("os");
        
        $osInfoResponse = $this->callAPI('GET', "{$apiUrl}/order/{$productId}", $username, $password);
        if (!$osInfoResponse || !isset($osInfoResponse['product'])) {
            $this->addError('Failed to retrieve OS information.');
        }
        
        $templateId = null;
        foreach ($osInfoResponse['product']['config']['forms'] as $form) {
            if ($form['title'] == 'OS') {
                $templateId = $form['id'];
                break;
            }
        }
        if (!$templateId) {
            $this->addError('Template ID could not be found.');
        }
        
        $osId = null;
        foreach ($osInfoResponse['product']['config']['forms'] as $form) {
            if ($form['title'] == 'OS') {
                foreach ($form['items'] as $item) {
                    if ($item['title'] == $selectedOsName) {
                        $osId = $item['id'];
                        break;
                    }
                }
            }
        }
        if (!$osId) {
            $this->addError('OS ID could not be found for the selected OS.');
        }
        
        $vmCreateResponse = $this->callAPI('POST', "{$apiUrl}/order/instances/{$productId}", $username, $password, [
            "cycle" => "m",
            "promocode" => $promocode,
            "domain" => $hostname,
            "custom" => [$templateId => $osId],
        ]);

        if (!$vmCreateResponse || isset($vmCreateResponse['error'])) {
            $this->addError($vmCreateResponse['error'] ?? 'Failed to create VM.');
            return false;
        }
        
        $this->orderId = $vmCreateResponse['items'][0]['id'] ?? '';
        if (!$this->orderId) {
            $this->addError('Order ID could not be retrieved.');
            return false;
        }
        
        $vmId = null;
        $startTime = time();
        while (!$vmId && (time() - $startTime < 120)) {
            $vmDetailsResponse = $this->callAPI('GET', "{$apiUrl}/service/{$this->orderId}/vms/", $username, $password);
            if (isset($vmDetailsResponse['vms']) && !empty($vmDetailsResponse['vms'])) {
                $vmId = array_key_first($vmDetailsResponse['vms']);
                break;
                return true;
            }
            sleep(15);
        }
        if (!$vmId) {
            $this->addError('VM details could not be retrieved within the specified time.');
            return false;
        }
        
        
        $isVmRunning = false;
        $startTime = time();
        while (!$isVmRunning && (time() - $startTime < 120)) {
            $vmInfo = $this->callAPI('GET', "{$apiUrl}/service/{$this->orderId}/vms/$vmId", $username, $password);
            if (isset($vmInfo['vm']) && $vmInfo['vm']['status'] === 'running') {
                $isVmRunning = true;
                break;
            }
            sleep(15);
        }

        if (!$isVmRunning) {
            $this->addError('VM is not in running status within the expected time.');
            return false;
        }
        
        if (isset($vmInfo['vm'])) {
           $orderId = $this->orderId;
           $vmid = $vmInfo['vm']['id'];
           $vmUsername = $vmInfo['vm']['username'];
           $vmPassword = $vmInfo['vm']['password'];
           $vmHostname = $vmInfo['vm']['label'];
           $vmdisk = $vmInfo['vm']['disk'];
           $vmcpus = $vmInfo['vm']['cpus'];
           $vmipv4 = $vmInfo['vm']['ipv4'];
           $vmipv6 = $vmInfo['vm']['ipv6'];

           $this->details["option4"]["value"] = $vmHostname;
           $this->details["option1"]["value"] = $vmUsername;
           $this->details["option2"]["value"] = $vmPassword;
           $this->details["option5"]["value"] = $vmPassword;
           $this->details["option15"]["value"] = $orderId;
           $this->details["option16"]["value"] = $vmid;
         }
         
         $this->addInfo("VM başarıyla oluşturuldu ve çalışıyor.");
         return true;
         
      } catch (Exception $e) {
        $this->addError("Hatayla karşılaşıldı: {$e->getMessage()}");
        return false;
      }
    }

    public function Suspend(){
    try {
        $username = $this->username;
        $password = $this->password;
        
        $orderId = $this->details["option15"]["value"];
        $vmId = $this->details["option16"]["value"];

        if (empty($orderId) || empty($vmId)) {
            throw new Exception("Failed to retrieve orderId and vmId.");
        }

        $apiUrl = "https://cloud.fibacloud.com/api/service/$orderId/vms/$vmId/stop";
        
        $response = $this->callAPI('POST', $apiUrl, $username, $password);

        if (isset($response['status']) && $response['status'] === true) {
            $this->addInfo("VM suspended successfully.");
            return true;
        } else {
            $errorMessage = $response['message'] ?? 'Unknown error occurred during suspension';
            $this->addError($errorMessage);
            return false;
        }
       } catch (Exception $e) {
        $this->addError("Error in Suspend function: {$e->getMessage()}");
        return false;
       }
    }
    
    public function Unsuspend(){
    try {
        $username = $this->username;
        $password = $this->password;
        
        $orderId = $this->details["option15"]["value"];
        $vmId = $this->details["option16"]["value"];

        if (empty($orderId) || empty($vmId)) {
            $this->addError("Failed to retrieve orderId and vmId.");
        }

        $apiUrl = "https://cloud.fibacloud.com/api/service/$orderId/vms/$vmId/start";
        
        $response = $this->callAPI('POST', $apiUrl, $username, $password);

        if (isset($response['status']) && $response['status'] === true) {
            $this->addInfo("VM unsuspended successfully.");
            return true;
        } else {
            $errorMessage = $response['message'] ?? 'Unknown error occurred during unsuspension';
            $this->addError($errorMessage);
            return false;
        }
       } catch (Exception $e) {
        $this->addError("Error in Unsuspend function: {$e->getMessage()}");
        return false;
       }
    }
    
    public function Terminate(){
    try {
        $username = $this->username;
        $password = $this->password;
        
        $orderId = $this->details["option15"]["value"];
        
        if (empty($orderId)) {
            $this->addError("Failed to retrieve orderId from service.");
            return false;
        }
        
        $apiUrl = "https://cloud.fibacloud.com/api/service/instances/$orderId/cancel";
        
        $response = $this->callAPI('POST', $apiUrl, $username, $password, [
            'immediate' => 'true',
            'reason' => 'terminated by HostBill'
        ]);
        
        if (isset($response['info']) && (in_array('cancell_sent', $response['info']) || in_array('cancelled_already', $response['info']))) {
            $this->addInfo('Service terminated successfully.');
            return true;
        } else {
            $this->addError('An error occurred during termination: ' . json_encode($response));
            return false;
        }
       } catch (Exception $e) {
        $this->addError('API Call Failed: ' . $e->getMessage());
        return false;
       }
    }
    
    public function PowerON(){
    try {
        $username = $this->username;
        $password = $this->password;
        
        $orderId = $this->details["option15"]["value"];
        $vmId = $this->details["option16"]["value"];

        if (empty($orderId) || empty($vmId)) {
            $this->addError("Failed to retrieve orderId and vmId.");
        }

        $apiUrl = "https://cloud.fibacloud.com/api/service/$orderId/vms/$vmId/start";
        
        $response = $this->callAPI('POST', $apiUrl, $username, $password);

        if (isset($response['status']) && $response['status'] === true) {
            $this->addInfo("VM successfully started.");
            return true;
        } else {
            $errorMessage = $response['message'] ?? 'Unknown error occurred during vm start';
            $this->addError($errorMessage);
            return false;
        }
       } catch (Exception $e) {
        $this->addError("Error in PowerON function: {$e->getMessage()}");
        return false;
       }
    }
    
    public function PowerOff(){
    try {
        $username = $this->username;
        $password = $this->password;
        
        $orderId = $this->details["option15"]["value"];
        $vmId = $this->details["option16"]["value"];

        if (empty($orderId) || empty($vmId)) {
            $this->addError("Failed to retrieve orderId and vmId.");
        }

        $apiUrl = "https://cloud.fibacloud.com/api/service/$orderId/vms/$vmId/stop";
        
        $response = $this->callAPI('POST', $apiUrl, $username, $password);

        if (isset($response['status']) && $response['status'] === true) {
            $this->addInfo("VM successfully stopped.");
            return true;
        } else {
            $errorMessage = $response['message'] ?? 'Unknown error occurred during vm stop';
            $this->addError($errorMessage);
            return false;
        }
       } catch (Exception $e) {
        $this->addError("Error in PowerOff function: {$e->getMessage()}");
        return false;
       }
    }
    
    public function ShutDown(){
    try {
        $username = $this->username;
        $password = $this->password;
        
        $orderId = $this->details["option15"]["value"];
        $vmId = $this->details["option16"]["value"];

        if (empty($orderId) || empty($vmId)) {
            $this->addError("Failed to retrieve orderId and vmId.");
        }

        $apiUrl = "https://cloud.fibacloud.com/api/service/$orderId/vms/$vmId/shutdown";
        
        $response = $this->callAPI('POST', $apiUrl, $username, $password);

        if (isset($response['status']) && $response['status'] === true) {
            $this->addInfo("VM successfully stopped.");
            return true;
        } else {
            $errorMessage = $response['message'] ?? 'Unknown error occurred during vm shutdown';
            $this->addError($errorMessage);
            return false;
        }
       } catch (Exception $e) {
        $this->addError("Error in ShutDown function: {$e->getMessage()}");
        return false;
       }
    }
    
    public function Reboot(){
    try {
        $username = $this->username;
        $password = $this->password;
        
        $orderId = $this->details["option15"]["value"];
        $vmId = $this->details["option16"]["value"];

        if (empty($orderId) || empty($vmId)) {
            $this->addError("Failed to retrieve orderId and vmId.");
        }

        $apiUrl = "https://cloud.fibacloud.com/api/service/$orderId/vms/$vmId/reboot";
        
        $response = $this->callAPI('POST', $apiUrl, $username, $password);

        if (isset($response['status']) && $response['status'] === true) {
            $this->addInfo("VM successfully rebooted.");
            return true;
        } else {
            $errorMessage = $response['message'] ?? 'Unknown error occurred during vm reboot';
            $this->addError($errorMessage);
            return false;
        }
       } catch (Exception $e) {
        $this->addError("Error in Reboot function: {$e->getMessage()}");
        return false;
       }
    }
    
    public function Reset(){
    try {
        $username = $this->username;
        $password = $this->password;
        
        $orderId = $this->details["option15"]["value"];
        $vmId = $this->details["option16"]["value"];

        if (empty($orderId) || empty($vmId)) {
            $this->addError("Failed to retrieve orderId and vmId.");
        }

        $apiUrl = "https://cloud.fibacloud.com/api/service/$orderId/vms/$vmId/reset";
        
        $response = $this->callAPI('POST', $apiUrl, $username, $password);

        if (isset($response['status']) && $response['status'] === true) {
            $this->addInfo("VM successfully restarted.");
            return true;
        } else {
            $errorMessage = $response['message'] ?? 'Unknown error occurred during vm reset';
            $this->addError($errorMessage);
            return false;
        }
       } catch (Exception $e) {
        $this->addError("Error in Reset function: {$e->getMessage()}");
        return false;
       }
    }
    
    public function Reinstall($params) {
    $username = $this->username;
    $password = $this->password;

    $orderId = $this->details["option15"]["value"];
    $vmId = $this->details["option16"]["value"];
    $templateId = $params['os'];

    if (empty($orderId) || empty($vmId)) {
        $this->addError("Failed to retrieve orderId and vmId.");
        return false;
    }

    $apiUrl = "https://cloud.fibacloud.com/api/service/$orderId/vms/$vmId/rebuild";

    try {
        $response = $this->callAPI('POST', $apiUrl, $username, $password, ['template' => $templateId]);
        $responseArray = json_decode($response, true);

        if (isset($responseArray['status']) && $responseArray['status'] == 1) {
            if (!empty($responseArray['error'])) {
                $errorMessage = implode(", ", $responseArray['error']);
                $this->addError("Rebuild Error: " . $errorMessage);
                return false;
            }
            return true;
        } else {
            return false;
        }
      } catch (Exception $e) {
        $this->addError("API Call Failed: " . $e->getMessage());
        return false;
      }
    } 

    public function GetVmDetails() {
    try {
        $username = $this->username;
        $password = $this->password;
        
        $orderId = $this->details["option15"]["value"];
        $vmId = $this->details["option16"]["value"];

        if (empty($orderId) || empty($vmId)) {
            $this->addError("Failed to retrieve orderId and vmId.");
        }

        $apiUrl = "https://cloud.fibacloud.com/api/service/$orderId/vms/$vmId";
        
        $response = $this->callAPI('GET', $apiUrl, $username, $password);

        if (!empty($response) && isset($response['vm'])) {
            return $response['vm'];
        } else {
            $this->addError("VM details not found in the API response.");
        }
        } catch (Exception $e) {
        $this->addError("Error in GetVmDetails function: {$e->getMessage()}");
        return false;
       }
    }
    
    public function GetTemplates() {
    try {
        $username = $this->username;
        $password = $this->password;
        
        $orderId = $this->details["option15"]["value"];

        if (empty($orderId)) {
            $this->addError("Failed to retrieve orderId.");
            return false;
        }

        $apiUrl = "https://cloud.fibacloud.com/api/service/$orderId/templates";
        
        $response = $this->callAPI('GET', $apiUrl, $username, $password);

        if (isset($response['templates'])) {
            return $response['templates'];
        } else {
            $this->addError("Templates not found in the response.");
        }
       } catch (Exception $e) {
        $this->addError("Error in GetTemplates function: {$e->getMessage()}");
        return false;
       }
    }
    
    public function ChangePackage(){
        $this->addInfo("Note: This is manual module for reference only, it dont support automatical account functions");
        return true;
    }
    
    public function addUser($username, $password, $oldpass = false){
    $this->details["option1"]["value"] = $username;
    $this->details["option2"]["value"] = $password;
    }
    
    public function addDomain($domain){
        $this->details["option4"]["value"] = $domain;
    }
    
    public function setPackage($package){
    }
    
    public function optionPackage($package){
    }
    
    public function getPackage(){
    }
    
    public function setRootPass($pass){
        parent::setRootPass($pass);
        $this->details["option5"]["value"] = $pass;
    }
}

?>
