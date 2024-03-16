{if $VMDetails.status=='online'}
    <a href="?cmd=clientarea&action=services&service={$service_id}&vpsdo=shutdown&security_token={$security_token}" class="state_switch on" onclick="return powerchange(this,'Are you sure you want to Power OFF this VM?');">
        {$lang.On}
    </a>
{else}
    <a href="?cmd=clientarea&action=services&service={$service_id}&vpsdo=startup&security_token={$security_token}" class="state_switch off" onclick="return powerchange(this,'Are you sure you want to Power ON this VM?');">
        {$lang.Off}
    </a>
{/if}