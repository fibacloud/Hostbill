<div class="header-bar">
    <h3 class="{$vpsdo} hasicon">Rebuild</h3>

    <div class="clear"></div>
</div>
<div class="content-bar nopadding">
    <div style="padding:0px 15px 15px">
        <h3><br/>{$lang.ReinstallVPS}<br/></h3>
        {$lang.choose_template1} <span style='color="#cc0000"'>{$lang.choose_template2}</span>
    </div>
    {if $ostemplates}
        <form action="" method="post">
            <table width="100%" cellspacing="0" cellpadding="0" border="0" class="checker table-label-value table-rw-stack ">
                <tr>
                    <td colspan="2">
                        <span class="slabel">{$lang.ostemplate}</span>
                        <select style="min-width:250px;" required="required" name="os" id="virtual_machine_template_id" onchange="swapcheck($(this).val())" >
                            {foreach from=$ostemplates item=template}
                            {if $template.name|strpos:"Windows" !== 0}
                            <option value="{$template.id}">{$template.name}</option>
                            {/if}
                            {/foreach}
                        </select>
                    </td>
                </tr>
                <tr>
                    <td><div class="form-group"><div class="col-sm-12 text-center"><label for="confirm" class="control-label">I understand, that reinstalling OS will <strong class="text-danger">ERASE ALL DATA STORED ON SERVER</strong></label></div></div></td>
                    <td colspan="2" align="center" style="border-bottom:none"> <input type="submit" value="{$lang.ReinstallVPS}" name="changeos" class="blue" /></td>
                </tr>
            </table>
            {securitytoken}
        </form>
    {else}
        <div style="color: red; text-align: center; width:850px">
            <strong>{$lang.ostemplates_error}</strong>
        </div>
    {/if}
</div>