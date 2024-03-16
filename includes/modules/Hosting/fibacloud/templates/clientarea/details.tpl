<div class="header-bar">
    <h3 class="vmdetails hasicon">{$lang.servdetails}</h3>
</div>
{literal}
    <style>
        .status-bar {
            background: url("templates/common/cloudhosting/images/progress-bg.png") repeat scroll 0 0 #5A5A5A;
            border-bottom: 1px solid #8F8F8F;
            border-radius: 3px 3px 3px 3px;
            border-top: 1px solid #555555;
            clear: both;
            height: 20px;
            position: relative;
            overflow: hidden;
        }
        .status-bar p{
            margin:0;
            position: relative;
            z-index: 1;
            color: white;
            padding: 0 5px
        }
        .status-bar .usage{
            background: url("templates/common/cloudhosting/images/bg_header1.png") repeat scroll 0 -14px #5A5A5A;
            border-bottom: 1px solid #2B5177;
            border-radius: 3px 3px 3px 3px;
            border-top: 1px solid #87BCE4;
            height: 18px;
            left: 1px;
            position: absolute;
            top: 0;
            z-index: 0;
        }
    </style>
{/literal}
<div class="content-bar" >
    <div class="right" id="lockable-vm-menu"> {include file="`$onappdir`ajax.vmactions.tpl"} </div>

    <div class="clear"></div>
    {cloudservices section='details'
    include="../common/cloudhosting/tpl/details.tpl"
    }
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <tr>
            <td width="50%" style="padding-right:10px;">
                <table cellpadding="0" cellspacing="0" width="100%" class="ttable">
                    <tr>
                        <td width="120">
                            <b>{$lang.status}</b>
                        </td>
                        <td style="padding:8px 5px 9px;">
                            {if !$VMDetails.locked}
                                {if $VMDetails.status=='running'}
                                    <a {if $o_sections.o_startstop}href="?cmd=clientarea&action=services&service={$service.id}&vpsdo=shutdown&vpsid={$VMDetails.id}&security_token={$security_token}" onclick="return powerchange(this, 'Are you sure you want to Power OFF this VM?');"{else}href="#" onclick="return
    false;"{/if} class="state_switch on" >{$lang.On}</a>
                                {else}
                                    <a {if $o_sections.o_startstop}href="?cmd=clientarea&action=services&service={$service.id}&vpsdo=startup&vpsid={$VMDetails.id}&security_token={$security_token}" onclick="return
    powerchange(this, 'Are you sure you want to Power ON this VM?');"{else}href="#"  onclick="return
    false;"{/if} class="state_switch off" >{$lang.Off}</a>
                                {/if}
                            {else}
                                <a href="?cmd=clientarea&action=services&service={$service.id}&vpsid={$vm.id}" class="state_switch">
                                    {$VMDetails.status}
                                </a>
                                <a class="fs11 left" href="?cmd=clientarea&action=services&service={$service.id}&vpsdo=vmdetails&vpsid={$VMDetails.id}" style="padding-left:10px;">{$lang.refresh}</a>
                            {/if}
                        </td>
                    </tr>
                    <tr>
                        <td><strong>{$lang.label}</strong></td>
                        <td>{$VMDetails.label}</td>
                    </tr>
                    <tr>
                        <td><strong>{$lang.username}</strong></td>
                        <td>{$VMDetails.username}</td>
                    </tr>
                    <tr>
                        <td><strong>{$lang.password}</strong></td>
                        <td><a href="#" class="{if $VMDetails.template_name == 'Windows Server 2016' or $VMDetails.template_name == 'Windows Server 2019' or $VMDetails.template_name == 'Windows Server 2022'}d-none{/if}" onclick="$(this).hide(); $('#rootpss').show(); return false;" style="color:red">{$lang.show}</a> <input id="rootpss" style="display:none; border: none; background: none; padding: 0; margin: 0; box-shadow: none;" readonly value="{$VMDetails.password}"/></td>
                    </tr>
                    <tr>
                        <td><strong>{$lang.ipadd} (IPv4)</strong></td>
                        <td>{$VMDetails.ipv4}</td>
                    </tr>
                    <tr>
                        <td><strong>{$lang.ipadd} (IPv6)</strong></td>
                        <td>{$VMDetails.ipv6}</td>
                    </tr>
                    <tr class="lst">
                        <td><strong>{$lang.ostemplate}</strong></td>
                        <td>{$VMDetails.template_name}</td>
                    </tr>
                </table>
            </td>
            <td width="50%" style="padding-left:10px;">
                <table  cellpadding="0" cellspacing="0" width="100%" class="ttable">
                    <tr>
                        <td><strong>VM ID</strong></td>
                        <td>{$VMDetails.id}</td>
                    </tr>
                    <tr>
                        <td><strong>CPU</strong></td>
                        <td valign="top">{$VMDetails.cpus}</td>
                    </tr>
                    <tr>
                        <td class="lst"><strong>RAM</strong></td>
                        <td valign="top">{$VMDetails.memory} MB</td>
                    </tr>
                    <tr>
                        <td class="lst"><strong>Storage</strong></td>
                        <td valign="top">{$VMDetails.disk} GB</td>
                    </tr>
                    <tr>
                        <td class="lst"><strong>{$lang.bandwidth}</strong></td>
                        <td valign="top">
                            <strong>Data Received:</strong> {$VMDetails.bandwidth.data_received/1024/1024/1024|number_format:0:",":"."} GB<br>
                            <strong>Data Sent:</strong> {$VMDetails.bandwidth.data_sent/1024/1024/1024|number_format:0:",":"."} GB
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    {/cloudservices}
</div>