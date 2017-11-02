$(document).on('click', '.participate_button', function(){
    var community_id = $('input:hidden[name="community_id"]').val();
    var user_id = $('input:hidden[name="user_id"]').val();
    if($('.participate_button').hasClass("participate")){
        $.ajax({
            url: '/communities/' + community_id + '/participate_in',
            type: 'post',
            data: { 'user_id': user_id }
        })
            .done(function() {
                $('.participate_button').removeClass("participate")
                    .addClass("participating")
                    .html('参加中')
        })
            .fail(function(jqXHR, textStatus, errorThrown){
                alert('サーバーとの通信に失敗しました。');
                console.log("XMLHttpRequest : " + jqXHR.status);
                console.log("textStatus     : " + textStatus);
                console.log("errorThrown    : " + errorThrown.message);
            });
    }else{
        $.ajax({
            url: '/communities/' + community_id + '/participate_in',
            type: 'delete',
            data: { 'user_id': user_id }
        })
            .done(function(data) {
                $('.participate_button').removeClass("participating")
                    .addClass("participate")
                    .html('参加する')
            })
            .fail(function(jqXHR, textStatus, errorThrown) {
                alert('サーバーとの通信に失敗しました。');
                console.log("XMLHttpRequest : " + jqXHR.status);
                console.log("textStatus     : " + textStatus);
                console.log("errorThrown    : " + errorThrown.message);
            });
    }
});