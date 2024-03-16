{literal}
    <script type="text/javascript">
        function bindMe() {
            $('#tabbedmenu').TabbedMenu({elem: '.tab_content', picker: 'li.tpicker', aclass: 'active'});
        }
        appendLoader('bindMe');
    </script>
{/literal}
<form action="" method="post" id="account_form" >
    <input type="hidden" value="{$details.firstpayment}" name="firstpayment" />
    <input type="hidden" name="account_id" value="{$details.id}" id="account_id" />
    <div class="blu">{include file='_common/accounts_nav.tpl'}</div>

    <div class="lighterblue" id="ChangeOwner" style="display:none;padding:5px;">
    </div>

    <div id="ticketbody" >
        {include file='_common/accounts_billing.tpl'}

        <ul class="tabs" id="tabbedmenu">
            <li class="tpicker active"><a href="#tab1" onclick="return false">Provisioning</a></li>
            {if $details.status == 'Active' || $details.status == 'Suspended'}
                <li class="tpicker"><a href="#tab2" onclick="return false">Virtual Machine</a></li>
            {/if}
            <li class="tpicker"><a href="#tab3" onclick="return false">Addons<span id="numaddons" class="top_menu_count">{$details.addons}</span> </a></li>
        </ul>
        <div class="tab_container">
            <div class="tab_content" style="display: block;">

                {include file='_common/accounts_details.tpl'}
            </div>
            {if $details.status == 'Active' || $details.status == 'Suspended'}
                <div class="tab_content" style="display: none;">

                    <div id="lmach">
                        <br />
                    </div>

                </div>
            {/if}
            <div class="tab_content" style="display: none;">
                {include file='_common/accounts_addons.tpl'}
            </div>
        </div>

        <div class="clear"></div>
        {include file='_common/accounts_multimodules.tpl'}
        {include file='_common/noteseditor.tpl'}

    </div>



    <div class="blu">{include file='_common/accounts_nav.tpl'}</div>
    {securitytoken}
</form>
{literal}
<script type="text/javascript">
    function show_nodes() {
        var url ={/literal} '?cmd=accounts&action=edit&id={$details.id}&service={$details.id}';{literal}
        var inp = $('input[name="extra_details[option10]"]');
        inp.wrap('<div class="left" />');
        inp.parent().addLoader();
        $.post(url, {vpsdo: 'list_nodes', 'current': inp.val()}, function (data) {
            var r = parse_response(data);
            inp.parent().replaceWith(r);
        });
    }
    function sync_alert() {
        var tab = $('#tabbedmenu li a[href=#tab2]');
        if (!tab.parent().is('.active'))
            $('#tabbedmenu li a[href=#tab2]').append('<span id="numaddons" class="top_menu_count"><b style="color:red">1</b></span>').bind('click.note', function () {
                $(this).unbind('click.note').find('span').remove();
            });
    }
    function load_clientvm(loader, sync) {
        if (loader != undefined)
            $('#lmach').addLoader();
        ajax_update('{/literal}?cmd=accounts&action=edit&id={$details.id}&service={$details.id}&vpsdo=clientsvms{literal}' + (sync != undefined && sync == 'sync' ? '&synchronize=sync' : '') + (sync > 0 ? '&synchronize=' + sync : ''), '', '#lmach');
    }
    function shutdown_clientvm() {
        ajax_update('{/literal}?cmd=accounts&action=edit&id={$details.id}&service={$details.id}&vpsdo=shutdown{literal}', '');
        load_clientvm(true);
    }
    function stop_clientvm() {
        ajax_update('{/literal}?cmd=accounts&action=edit&id={$details.id}&service={$details.id}&vpsdo=stop{literal}', '');
        load_clientvm(true);
    }
    function startup_clientvm() {
        ajax_update('{/literal}?cmd=accounts&action=edit&id={$details.id}&service={$details.id}&vpsdo=startup{literal}', '');
        load_clientvm(true);
    }
    function reboot_clientvm() {
        ajax_update('{/literal}?cmd=accounts&action=edit&id={$details.id}&service={$details.id}&vpsdo=reboot{literal}', '');
        load_clientvm(true);
    }
    function reset_clientvm() {
        ajax_update('{/literal}?cmd=accounts&action=edit&id={$details.id}&service={$details.id}&vpsdo=reset{literal}', '');
        load_clientvm(true);
    }
    function destroyVM_onapp(url) {
        if (confirm('Are you sure you wish to destroy this VM?')) {
            $('#lmach').addLoader();
            ajax_update(url, '', '#lmach');
        }
        return false;
    }
    function power_onapp(url, what) {
        var conf = what == 'off' ? confirm('Are you sure you wish to power-off this VM?') : true;
        if (conf) {
            $('#lmach').addLoader();
            ajax_update(url + '&power=' + what, '', '#lmach');
        }
        return false;
    }
    function loadClientMachines_onapp() {
        var url ={/literal} '?cmd=accounts&action=edit&id={$details.id}&service={$details.id}&vpsdo=clientsvms';{literal}
        ajax_update(url, '', '#lmach', true);

        setInterval(function () {
            if (!$('#tabbedmenu .tpicker').eq(2).hasClass('active'))
                return;
            $('#lmach').addLoader();
            ajax_update(url, '', '#lmach');
        }, 20000);
    }
    appendLoader('loadClientMachines_onapp');
</script>

<style type="text/css">
    ul.accor li > div.darker {
        background:#e3e2e4 !important;
        border-bottom:1px solid #d7d7d7  !important;
        border-left:1px solid #d7d7d7  !important;
        border-right:1px solid #d7d7d7  !important;
    }
    ul.accor li > a.darker {
        background:url("{/literal}{$template_dir}{literal}img/plus1.gif") no-repeat scroll 6px 50% #444547 !important;
    }
    #lmach {
        padding:10px;
    }
    a.power {
        float: left;
        display: block;
        width: 31px;
        height: 19px;
        margin-left: 3px;
        text-decoration: none;
        text-align: center;
        color: #555 !important;
        cursor: default;
    }
    a.power.on-inactive, a.power.off-inactive, a.power.on-disabled, a.power.off-disabled {
        background: transparent url({/literal}{$system_url}{literal}templates/common/cloudhosting/images/power-bg.png) no-repeat scroll 0 0;
    }

    a.power.on-inactive:hover {
        background: transparent url({/literal}{$system_url}{literal}templates/common/cloudhosting/images/power-bg.png) no-repeat scroll -32px 0;
    }

    a.power.off-inactive:hover {
        background: transparent url({/literal}{$system_url}{literal}templates/common/cloudhosting/images/power-bg.png) no-repeat scroll -64px 0;
    }

    a.power.on-active {
        background: transparent url({/literal}{$system_url}{literal}templates/common/cloudhosting/images/power-bg.png) no-repeat scroll -96px 0;
    }

    a.power.off-active {
        background: transparent url({/literal}{$system_url}{literal}templates/common/cloudhosting/images/power-bg.png) no-repeat scroll -128px 0;
    }
    .power.pending {
        background: transparent url({/literal}{$system_url}{literal}templates/common/cloudhosting/images/power-bg.png) no-repeat scroll -160px 0;
        width: 65px;
        color: #909090 !important;
    }
    .vm-overview a.power {
        margin-left: 0;
        margin-right: 3px;
        text-shadow: none;
    }
    a.power.on-inactive:hover, a.power.off-inactive:hover {
        cursor: pointer;
        color: #fafafa !important;
    }

    a.power.on-active {
        color: #efe !important;
    }

    a.power.off-active {
        color: #fee !important;
    }

    a.power.on-disabled, a.power.off-disabled {
        color: #909090 !important;
        opacity: 0.8;
    }
    .power-status .yes {
        background:url("{/literal}{$system_url}{literal}templates/common/cloudhosting/images/vm-on.png") no-repeat scroll 0 0 transparent;
        display:block;
        height:16px;
        text-indent:-99999px;
        width:16px;
    }
    .power-status .no {
        background:url("{/literal}{$system_url}{literal}templates/common/cloudhosting/images/vm-off.png") no-repeat scroll 0 0 transparent;
        display:block;
        height:16px;
        text-indent:-99999px;
        width:16px;
    }
    .right-aligned {
        text-align:right;
    }
    .ttable td {
        padding:3px 4px;
    }
    table.data-table.backups-list thead {
        border:1px solid #DDDDDD;
    }
    table.data-table.backups-list thead {
        border-left:1px solid #005395;
        border-right:1px solid #005395;
    }
    table.data-table.backups-list thead {
        font-size:80%;
        font-weight:bold;
        text-transform:uppercase;
    }
    table.data-table.backups-list thead td {
        background:none repeat scroll 0 0 #777777;
        color:#FFFFFF;
        padding:8px 5px;
    }
    table.data-table tbody td {
        background:none repeat scroll 0 0 #FFFFFF;
        border-top:1px solid #DDDDDD;
    }
    table.data-table tbody tr:hover td {
        background-color: #FFF5BD;
    }
    table.data-table tbody tr td {
        border-color:-moz-use-text-color #DDDDDD #DDDDDD;
        border-right:1px solid #DDDDDD;
        border-style:none solid solid;
        border-width:0 1px 1px;
        font-size:90%;
        padding:8px;
    }
</style>
{/literal}
