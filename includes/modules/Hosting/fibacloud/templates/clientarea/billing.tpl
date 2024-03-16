{include file="`$onappdir`header.cloud.tpl"}
<div class="header-bar">
    <h3 class="{$vpsdo} hasicon">Billing</h3>
    <div class="clear"></div>
</div>
<div class="content-bar ">
    <h3 class="summarize">Summary</h3>
    <table cellpadding="0" cellspacing="0" class="ttable cloud-billing table-rw-stack table-label-value" width="100%" style="margin-top:0px">
        <tr>
            <td class="title" width="160" align="right"><b>{$lang.registrationdate}</b></td>
            <td width="268">{$service.date_created|dateformat:$date_format}</td>
            <td class="title" align="right" width="160"><b>{$lang.status}</b></td>
            <td   width="268"><span class="{$service.status}"><strong>{$lang[$service.status]}</strong></span>
                {if $service.status=='Active' || $service.status=='Suspended'|| $service.status=='Pending'}
                    <a class="delete fs11 label label" href="{$ca_url}clientarea&action=services&service={$service.id}&cid={$service.category_id}&cancel">{$lang.cancelrequest}</a>
                {/if}
            </td>
        </tr>
        {if $service.showbilling &&  $service.billingcycle!='Free' && $service.billingcycle!='Once'}
            <tr>
                <td class="title" align="right">
                    <b>{if $service.billingcycle=='Hourly' || $service.metered}{$lang.curbalance}{else}{$lang.reccuring_amount}{/if}</b>
                </td>
                <td>
                    {if $service.metered_total}
                        {$service.metered_total|price:$currency}
                    {else}
                        {$service.total|price:$currency}{/if}
                    <span class="fs11">{if $service.billingcycle=='Hourly'}({$lang.updatedhourly}){elseif $service.metered}({$lang.Metered}){else}({$lang[$service.billingcycle]}){/if}</span>
                </td>
                {if $service.billingcycle!='Free' && $service.billingcycle!='Once'}
                    <td class="title" align="right"><b>Next invoice:</b></td>
                    <td>{$service.next_invoice|dateformat:$date_format}</td>
                {else}
                    <td colspan="2"></td>
                {/if}
            </tr>
        {/if}
    </table>
    <div class="mseparator"></div>
    {if $service.metered && $service.showbilling && ($service.status=='Active' || $service.status=='Suspended')}
        <h3 class="summarize">{$lang.nextinvoicedetails} <span>(updated hourly)</span></h3>
        {if $metered_summary}
            <div class="report">
                <div class="button green">
                    <span class="value">{$service.metered_total|price:$currency}</span>
                    <span class="attr">{$lang.Totaldue}</span>
                </div>
                {if $service.total}
                    <div class="button">
                        <span class="value">{$service.total|price:$currency}</span>
                        <span class="attr">{$lang[$service.billingcycle]}</span>
                    </div>
                {/if}

                {foreach from=$metered_summary item=vr}{if $vr.options & 4}{continue}{/if}
                    <div class="button">
                        <span class="value">{$vr.charge|price:$currency:true:false:true:4}</span>
                        <span class="attr">{$vr.name}</span>
                    </div>
                {/foreach}
            </div>
        {/if}
        <div class="mseparator"></div>
        {* metered table *}
        <div id="pricingdetails">
            <div style="margin-bottom:8px;padding-bottom:2px;border-bottom:1px solid #DADBDD">
                <h3 class="summarize left" style="border-bottom:none;margin:0px;padding:0px;">{$lang.usagedetails}</h3>
                <div class="right">
                    {$lang.Interval} <select name="metered_interval" id="metered_interval"
                                             onchange="metteredBillinghistory()">
                        <option value="1h">{$lang.onehour}</option>
                        <option value="1d">{$lang.oneday}</option>

                    </select>
                    {$lang.entermonth} <select name="metered_period" id="metered_period"
                                               onchange="metteredBillinghistory()">
                        {foreach from=$metered_periods item=p}
                            <option value="{$p}">{$p}</option>
                        {/foreach}
                    </select>
                </div>
                <div class="clear"></div>
            </div>
            <div id="pricingtable"> {include file="`$onappdir`metered_table.tpl"}</div>
            <div class="clear"></div>
        </div>
    {/if}
    {if $service.custom}
        <table class="table table-striped table-aff-center p-top">
            {foreach from=$service.custom item=cst}
                <tr>
                    <td class="w30 bold">{$cst.name}  </td>
                    <td>{include file=$cst.configtemplates.clientarea} </td>
                </tr>
            {/foreach}
        </table>
    {/if}
    {if $addons}
        <table cellpadding="0" cellspacing="0" class="ttable" width="100%">
            <tr>
                <td colspan="4">
                    <div>
                        <strong>{$lang.accaddons|capitalize}</strong>
                        <div>
                            <table width="100%" cellspacing="0" cellpadding="0" border="0" class="checker">
                                <tr>
                                    <td colspan="2" style="border:none">
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%" class="styled">
                                            <colgroup class="firstcol"></colgroup>
                                            <colgroup class="alternatecol"></colgroup>
                                            <colgroup class="firstcol"></colgroup>
                                            <colgroup class="alternatecol"></colgroup>
                                            <tbody>
                                            <tr>
                                                <th width="40%" align="left">{$lang.addon}</th>
                                                <th align="left">{$lang.price}</th>
                                                <th>{$lang.nextdue}</th>
                                                <th>{$lang.status}</th>
                                            </tr>
                                            {foreach from=$addons item=addon name=foo}
                                                <tr {if $smarty.foreach.foo.index%2 == 0}class="even"{/if}>
                                                    <td>{$addon.name}</td>
                                                    <td>{$addon.recurring_amount|price:$currency}</td>
                                                    <td align="center">{$addon.next_due|dateformat:$date_format}</td>
                                                    <td align="center"><span
                                                                class="{$addon.status}">{$lang[$addon.status]}</span>
                                                    </td>
                                                </tr>
                                            {/foreach}
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    {$service.id|string_format:$lang.clickaddaddons}
                </td>
            </tr>
        </table>
    {elseif $haveaddons && $service.status!='Fraud' && $service.status!='Cancelled' && $service.status!='Terminated'}
        <table cellpadding="0" cellspacing="0" class="ttable" width="100%">
            <tr>
                <td colspan="4">
                    <div><strong>{$lang.accaddons|capitalize}</strong></div>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    {$service.id|string_format:$lang.clickaddaddons}
                </td>
            </tr>
        </table>
    {/if}
</div>

{include file="`$onappdir`footer.cloud.tpl"}