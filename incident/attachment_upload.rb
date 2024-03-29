# begin
@log.trace("Started executing 'flint-snow:incident:attachment_upload.rb' flintbit...")
begin
    # Flintbit Input Parameters
    @connector_name = @input.get('connector_name') # Name of the ServiceNow Connector
    if @connector_name.nil?
       @connector_name = @config.global("flintserve.connector_name")
      if @connector_name.nil?
       @connector_name = 'servicenow'
    end
   end
    @action = 'upload-attachment'                     # Contains the name of the operation: list
    @tableName = 'incident'
    @sysid = @input.get('sys-id')
    @filename = @input.get('file-name')
   # @sysparm_display_value = @input.get('sysparm_display_value')

    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} |action :: #{@action}| tableName :: #{@tableName}")

          response = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('table-name', @tableName)
                          .set('sys-id', @sysid)
                          .set('file-name', @filename)
                          .sync

    # ServiceNow Connector Response Meta Parameters
    response_exitcode = response.exitcode           # Exit status code
    response_message = response.message             # Execution status message

    # ServiceNow Connector Response Parameters
    response_body = response.get('body')            # Response body
    @log.info(response_body)
    if response_exitcode == 0
        @log.info("Success in executing servicenow Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.setraw('result', response_body)
        @log.trace("Finished executing 'servicenow' flintbit with success...")
    else
        @log.error("Failure in executing servicenow Connector where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.set('error', response_message)
        @log.trace("Finished executing 'servicenow' flintbit with error...")
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'flint-snow:incident:attachment_upload.rb' flintbit...")
# end
