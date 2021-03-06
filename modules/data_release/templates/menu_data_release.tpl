{if $superuser}

<button type="button" name = "upload" class = "btn btn-sm btn-primary" data-toggle="modal" data-target="#fileUploadModal">Upload File</button>

<div class="modal fade" id="fileUploadModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h3 class="modal-title" id="myModalLabel">Upload File</h3>
            </div>
            <form name = "uploadForm" id = "uploadForm" method = "POST" enctype="multipart/form-data" action="{$baseurl}/data_release/ajax/FileUpload.php">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-xs-12 form-group">
                            <label class="col-xs-4" for="file">File<font color="red"><sup> *</sup></font></label>
                            <div class="col-xs-8">
                                <input type="file" name="file" class="fileUpload" id="file" style = "margin-left: 1em;"/>
                            </div>
                        </div>
                        <div class="col-xs-12 form-group">
                            <label class="col-xs-4" for="version">Version</label>
                            <div class="col-xs-8">
                                <input type="text" size = "27" name="version" id="version" class="ui-corner-all form-fields form-control input-sm" />
                            </div>
                        </div>
                        <input type="hidden" name = "action" id = "action" value = "upload">
                        <input type="hidden" id="MAX_FILE_SIZE" name="MAX_FILE_SIZE" value="100000000" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary" id = "uploadButton" role="button" aria-disabled="false">Upload</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>


<button type="button" name = "permission" class = "btn btn-sm btn-primary" data-toggle="modal" data-target="#permissionModal">Add Permission</button>

<div class="modal fade" id="permissionModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h3 class="modal-title" id="myModalLabel">Add Permission</h3>
            </div>
            <form name = "uploadForm" id = "uploadForm" method = "POST" enctype="multipart/form-data" action="{$baseurl}/data_release/ajax/AddPermission.php">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-xs-12 form-group">
                            <label class="col-xs-4" for="userid">User ID</label>
                            <div class="col-xs-8">
                                <select name="userid" id = "userid" class = "form-fields form-control input-sm">
                                <option value=""> </option>
                                    {foreach from = $userids item=val key=k}
                                        <option value={$k}>{$val}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                        <div class="col-xs-12 form-group">
                            <label class="col-xs-4" for="data_release_id">Data Release ID</label>
                            <div class="col-xs-8">
                                <select name="data_release_id" id = "data_release_id" class = "form-fields form-control input-sm">
                                <option value=""> </option>
                                    {foreach from = $data_release_ids item=val key=k}
                                        <option value={$k}>{$val}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                        <input type="hidden" name = "action" id = "action" value = "addpermission">
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary" id = "uploadButton" role="button" aria-disabled="false">Add Permission</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

<br>
<br>

{/if}

<table class="table table-hover table-primary table-bordered table-data_release dynamictable" border="0">
    <thead>
        {section name=header loop=$headers}
            <th class="info" nowrap="nowrap">
                    <a href="{$baseurl}/data_release/?filter[order][field]={$headers[header].name}&filter[order][fieldOrder]={$headers[header].fieldOrder}" class = "sortHeaders">
                        {$headers[header].displayName}
                    </a>
            </th>
        {/section}
    </thead>
<tbody>

{section name=item loop=$items}
    <tr>
        {section name=piece loop=$items[item]}
            {if $items[item][piece].name != ""}
                <td>
                    {if $items[item][piece].name == 'file_name'}
                        <a href="{$baseurl}/data_release/ajax/GetFile.php?File={$items[item][piece].value}" target="_blank" download="{$items[item][piece].value}">
                        {$items[item][piece].value}
                        </a>
                    {else}
                        {$items[item][piece].value}
                    {/if}
                </td>
            {/if}
        {/section}
    </tr>
{/section}

</tbody>
</table>
