$(document).ready(function(){
    scrollToBottom();
});
function scrollToBottom(){
	if ($('#messages').length) {
		$('#messages').animate({
        scrollTop: $('#messages')[0].scrollHeight}, 2000);
	}
	
}
// $('#new_message_form')
//  .bind('ajax:beforeSend', function(xhr, settings) {})
//  .bind('ajax:success',    function(xhr, data, status) {})
//  .bind('ajax:complete', function(xhr, status) { })
//  .bind('ajax:error', function(xhr, data, status) {})
function initialize_timer(){
	setInterval(fetch_message, 3000);
}
function fetch_message(){
	var _this = this;
    var conversation_id = $("#message_conversation_id").val();
    var last_viewed_time = $("#message_last_viewed_time").val();
    var fetch_message_endpoint = $("#fetch_message_endpoint").val() + ".js";

    $.ajax({type: "GET"
          , url: 		fetch_message_endpoint
          , dataType: 	"script"
          , data: 	{ 	conversation_id: conversation_id, 
          				last_viewed_time: last_viewed_time
          			}
          , success: 	function(js) {}
    }); 
}