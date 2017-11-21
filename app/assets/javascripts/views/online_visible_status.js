
function set_online_status(status){
	var set_status_endpoint = '/person_online_status/set_static';
	$.ajax({type: "POST"
          , url: 		set_status_endpoint
          , dataType: 	"json"
          , data: 	{ 	status: status
          			}
          , success: 	
			        function(result) {
			        	online_callback(status);
			        }
    });
}

function online_callback(status){
	var text = {
		online: 'Your clients and teammates will see that you are online',
		offline: 'Your clients and teammates will not see that you are online',
		away: "Your clients and teammates will see that you are away",
		brb: "Your clients and teammates will see that you'll be back soon",
	}
	var title = {
		online: 'Visible',
		offline: 'Invisible',
		away:'Away',
		brb: 'BRB'
	}
	$('.modal-body.viz-modal > h5').text(text[status]);
	$('h4#visibilityModalLabel.modal-title > span').text('You are now ' + title[status]);
	switch(status){
		case 'online':
			$('.online-status-modal .modal-content').removeAttr('class').addClass('modal-content viz-modal-visible');
			break;
		case 'offline':
			$('.online-status-modal .modal-content').removeAttr('class').addClass('modal-content viz-modal-invisible');
			break;
		case 'away':
			$('.online-status-modal .modal-content').removeAttr('class').addClass('modal-content viz-modal-away');
			break;
		case 'brb':
			$('.online-status-modal .modal-content').removeAttr('class').addClass('modal-content viz-modal-brb');
			break;
	}
}


function other_party_online_dialog()
{
	var other_party_online_dialog_endpoint = '/getotherpartyonlinestatus.js';
	$.ajax({type: "GET"
          , url: 		other_party_online_dialog_endpoint
          , dataType: 	"script"
          , data: 	{ 	
          			}
          , success: 	
			        function(result) {
			        	
			        }
    });
}
