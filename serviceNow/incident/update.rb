# begin
@log.trace("Started executing 'serviceNow:incident:update.rb' flintbit...")
begin
    # Flintbit Input Parameters
    @connector_name = @input.get('connector_name')                 # Name of the ServiceNow Connector
    if @connector_name.nil?
       @connector_name = 'servicenow'
    end
    @action = 'update-record'                     
    @tableName = 'incident' 
    @sysid  = @input.get('sys-id')
    @sysparm_display_value = @input.get('sysparm_display_value')

    data = @input.get('data') 
       
    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} |action :: #{@action}| tableName :: #{@tableName} | sysid :: #{@sysid} | 
state :: #{data}")

          response = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('table-name', @tableName)
                          .set('data', data)
                          .set('sysparm_display_value', @sysparm_display_value)
                          .set('sys-id', @sysid)
                          .sync
            

    # ServiceNow Connector Response Meta Parameters
    response_exitcode = response.exitcode           # Exit status code
    response_message = response.message             # Execution status message
   
    
    # ServiceNow Connector Response Parameters
  response_body = response.get('body')# Response body

    if response_exitcode == 0
        result = @util.json(response_body)
    
        @log.info("Success in executing serviceNow Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
        response= @call.bit("serviceNow:incident:get_process_data.rb").setraw(response_body).sync
        #@output.setraw('result', response_body)
        @output.set('result', response.get('data'))
        @log.info(":: Updated Sucessfully")
        @log.trace("Finished executing 'serviceNow' flintbit with success...")
    else
        @log.error("Failure in executing serviceNow Connector where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.set('error', response_message)
        @log.trace("Finished executing 'serviceNow' flintbit with error...")
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'serviceNow:incident:update.rb' flintbit...")
# end
