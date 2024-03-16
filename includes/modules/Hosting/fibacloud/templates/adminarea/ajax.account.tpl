{if $vpsdo == 'list_nodes'}
    <select name="extra_details[option10]" >
        {foreach from=$nodes item=type key=typename}
            <optgroup label="{$typename}">
                {foreach from=$type item=node}
                    <option {if $current == $node}selected="selected"{/if} value="{$node}">{$node}</option>
                {/foreach}
            </optgroup>
        {/foreach}
    </select>
{elseif $vpsdo == 'getstatus'}
    {if $status}<span class="yes">Yes</span>{else}<span class="no">No</span>{/if}
{elseif $vpsdo == 'clientsvms'}
    <table class="table table-striped table-hover">
        <thead>
        <tr>
            <td colspan="5">VPS Info</td>
        </tr>
        </thead>
        <tbody>
        {if $vm}
            <tr style="background-color: #eee;">
                <td class="right-aligned" width="33%">
                    <b>State</b>
                </td>
                <td class="power-status" >{if $vm.status == 'running'}<span class="yes left">Yes</span>{else}<span class="no left">No</span>{/if}
                    <div class="left">
                        {$vm.status|capitalize}
                        <button onclick="load_clientvm();
                                        $('#lmach').addLoader();
                                        return false;">Refresh</button>
                        {if $vm.status == 'running'}
                            <button onclick="reboot_clientvm();
                                            return false;">Reboot</button>
                            <button onclick="reset_clientvm();
                                            return false;">Reset</button>
                            <button onclick="shutdown_clientvm();
                                            return false;">Shutdown</button>
                            <button onclick="stop_clientvm();
                                            return false;">Hard Stop</button>
                        {elseif $vm.status == 'stopped'}
                            <button onclick="startup_clientvm();
                                            return false;">Power On</button>
                        {/if}
                        <a href="https://cloud.fibacloud.com" target="_blank">Go to Cloud Portal</a>
                    </div>
                </td>
            </tr>
            <tr style="background-color: #eee;">
                <td class="right-aligned"><b>Label</b></td>
                <td class="courier-font">{$vm.label}</td>
            </tr>
            <tr style="background-color: #eee;">
                <td class="right-aligned"><b>VM ID</b></td>
                <td class="courier-font">{$vm.id}</td>
            </tr>
            <tr style="background-color: #eee;">
                <td class="right-aligned"><b>Template</b></td>
                <td class="courier-font">{$vm.template_name}</td>
            </tr>
            <tr style="background-color: #eee;">
                <td class="right-aligned"><b>Username</b></td>
                <td class="courier-font">{$vm.username}</td>
            </tr>
            <tr style="background-color: #eee;">
                <td class="right-aligned"><b>Password</b></td>
                <td class="courier-font">{$vm.password}</td>
            </tr>
            <tr style="background-color: #eee;">
                <td class="right-aligned"><b>IPv4 Address</b></td>
                <td class="courier-font">
                    {foreach from=$vm.ipv4 item=adr}
                        <a style="display: block; width: 100px;" href="http://{$adr}">{$adr}</a>
                    {/foreach}
                </td>
            </tr>
            <tr style="background-color: #eee;">
                <td class="right-aligned"><b>IPv6 Address</b></td>
                <td class="courier-font">
                {foreach from=$vm.ipv6 item=adr}
                        {$adr}
                {/foreach}
                </td>
            </tr>
            <tr style="background-color: #eee;">
                <td class="right-aligned"><b>Bandwidth Data Received</b></td>
                <td class="courier-font">{$vm.bandwidth.data_received/1024/1024/1024|number_format:0:",":"."} GB</td>
            </tr>
            <tr style="background-color: #eee;">
                <td class="right-aligned"><b>Bandwidth Data Sent</b></td>
                <td class="courier-font">{$vm.bandwidth.data_sent/1024/1024/1024|number_format:0:",":"."} GB</td>
            </tr>
        {else}
            <tr>
                <td colspan="2">
                    No VMs created yet
                </td>
            </tr>
        {/if}
        </tbody>
    </table>
    <div class="clear"></div>
    {literal}
        <style>
            table.data-table tbody tr td{
                height:60px
            }
            span.infospan{
                border-bottom: 1px dashed #777777;
                cursor: help;    
            }
        </style>
        <script type="text/javascript">
            $('.infospan').each(function () {
                $(this).attr('title', 'This value is not accessible, and cannot be obtained from server at this time');
            }).vTip();
        </script>
    {/literal}
{/if}