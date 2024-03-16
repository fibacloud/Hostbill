<table class="tonapp" width="100%" cellspacing=0>
    <thead>
            <th><strong>Device</strong></th>
            <th><strong>{$lang.size}</strong></th>
            <th><strong>{$lang.type}</strong></th>
            <th><strong>Zone</strong></th>
    </thead>
    <tbody>
    {foreach from=$VMDetails.storage item=storage}
        <tr>
            <td>{$storage.type}</td>
            <td>{$storage.size_gb} GB</td>
            <td>{$storage.format}</td>
            <td>{$storage.zone}</td>
        </tr>
        {foreachelse}
        <tr>
            <td colspan="5">{$lang.nothing}</td>
        </tr>
    {/foreach}
    </tbody>
</table>