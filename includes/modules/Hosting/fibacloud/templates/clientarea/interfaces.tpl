<table class="tonapp" width="100%" cellspacing=0>
    <thead>
            <th><strong>Device</strong></th>
            <th><strong>Model</strong></th>
            <th><strong>MAC</strong></th>
            <th><strong>IPs</strong></th>
    </thead>
    <tbody>
    {foreach from=$VMDetails.interfaces item=interface}
        <tr>
            <td>{$interface.name}</td>
            <td>{$interface.model}</td>
            <td>{$interface.mac}</td>
            <td>{foreach from=$interface.ip item=ip}
            <div title="Network: {$ip.network} | Gateway: {$ip.gateway}">{$ip.ipaddress}</div>
        {/foreach}</td>
        </tr>
        {foreachelse}
        <tr>
            <td colspan="5">{$lang.nothing}</td>
        </tr>
    {/foreach}
    </tbody>
</table>