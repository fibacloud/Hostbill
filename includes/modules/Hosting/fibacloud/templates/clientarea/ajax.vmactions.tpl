{cloudservices section='actions'
include="../common/cloudhosting/tpl/actions.tpl"
}
<div id="lock" {if $VMDetails.locked}style="display:block"{/if}>
    <img src="templates/common/cloudhosting/images/ajax-loader.gif" alt=""> {$lang.server_performing_task}
    <a href="?cmd=clientarea&action=services&service={$service.id}&vpsdo=vmdetails">
        <b>{$lang.refresh}</b>
    </a>
</div>
<ul id="vm-menu" class="right">
    {if $VMDetails.status=='running'}
        <li>
                <a href="?cmd=clientarea&action=services&service={$service.id}&vpsdo=reboot&security_token={$security_token}" onclick="return confirm('{$lang.sure_to_reboot}?');">
                    <img alt="Reboot" src="templates/common/cloudhosting/images/icons/24_arrow-circle.png"><br>{$lang.reboot}
                </a>
        </li>
        <li>
            <a href="?cmd=clientarea&action=services&service={$service.id}&vpsdo=reset&security_token={$security_token}" onclick="return confirm('{$lang.sure_to_reset}?');">
                    <img alt="Reset" src="templates/common/cloudhosting/images/icons/24_arrow-circle.png"><br>{$lang.Reset}
            </a>
        </li>
        <li>
            <a href="?cmd=clientarea&action=services&service={$service.id}&vpsdo=shutdown&security_token={$security_token}" onclick="return confirm('Are you sure you wish to shutdown this VM?');">
                <img alt="Shutdown" src="templates/common/cloudhosting/images/icons/poweroff.png"><br>{$lang.Shutdown}
            </a>
        </li>
        <li>
            <a href="?cmd=clientarea&action=services&service={$service.id}&vpsdo=poweroff&security_token={$security_token}" onclick="return confirm('Are you sure you wish to Hard Stop this VM?');">
                <img alt="Stop" src="templates/common/cloudhosting/images/icons/poweroff.png"><br>Hard Stop
            </a>
        </li>
    {else}
        <li>
            <a href="?cmd=clientarea&action=services&service={$service.id}&vpsdo=startup&security_token={$security_token}" >
                <img alt="Startup" src="templates/common/cloudhosting/images/icons/poweroff.png"><br>{$lang.Startup}
            </a>
        </li>
    {/if}
    <li>
        <a href="?cmd=clientarea&action=services&service={$service.id}&vpsdo=reinstall&security_token={$security_token}" >
            <img alt="Rebuild" src="templates/common/cloudhosting/images/icons/24_blueprint.png"><br>{$lang.rebuild}
        </a>
    </li>
    {foreach from=$widgets item=widg key=wkey}
        <li class="widget">
            <a href="{$ca_url}clientarea/services/{$service.slug}/{$service.id}/&vpsdo=vmdetails&widget={$widg.name}{if $widg.id}&wid={$widg.id}{/if}">
                <img src="{$widg.config.bigimg}" alt=""><br/>{if $lang[$widg.name]}{$lang[$widg.name]}{elseif $widg.fullname}{$widg.fullname}{else}{$widg.name}{/if}
            </a>
        </li>
    {/foreach}
</ul>
{/cloudservices}
<div class="clear"></div>
{if !$VMDetails.locked}
    {literal}
        <script type="text/javascript">
            var wx = setTimeout(function() {
                $.post('{/literal}?cmd=clientarea&action=services&service={$service.id}{literal}', {vpsdo: 'vmactions'}, function(data) {
                    var r = parse_response(data);
                    if (r)
                        $('#lockable-vm-menu').html(r);
                });
            }, 4000);
        </script>
    {/literal}
{/if}
