<link media="all" type="text/css" rel="stylesheet" href="templates/common/cloudhosting/styles.css" />
<script type="text/javascript" src="templates/common/cloudhosting/js/scripts.js"></script>
<div class="cloud">
{if $widget.appendtpl }
    {include file=$widget.appendtpl}
{/if}
    {cloudservices
    section='header'
    include="../common/cloudhosting/tpl/header.tpl"}
<div id="nav-onapp">
    <h1 class="left os-logo {if $s_vm}{$s_vm.distro}{/if}">{if $s_vm.hostname}{$s_vm.hostname}{else}{$s_vm.label}{/if}</h1>
    <ul class="level-1">
        <li class="{if $vpsdo=='vmdetails'}current-menu-item{/if}"><a href="?cmd=clientarea&action=services&service={$service.id}&vpsdo=vmdetails"><span class="list-servers">{$lang.Overview}</span></a></li>
        <li class="{if $vpsdo=='storage'}current-menu-item{/if}"><a href="?cmd=clientarea&action=services&service={$service.id}&vpsdo=storage"><span class="addserver">{$lang.storage}</span></a></li>
        <li class="{if $vpsdo=='interfaces'}current-menu-item{/if}"><a href="?cmd=clientarea&action=services&service={$service.id}&vpsdo=interfaces"><span class="addserver">{$lang.interfaces}</span></a></li>
        <li class="{if $vpsdo=='billing'}current-menu-item{/if}"><a href="?cmd=clientarea&action=services&service={$service.id}&vpsdo=billing"><span class="addserver">{$lang.Billing}</span></a></li>
    </ul>
    <div class="clear"></div>
</div>
    {/cloudservices}
<div class="clear"></div>
<div id="content-cloud">
