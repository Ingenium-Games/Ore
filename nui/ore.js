/*

*/

let EnableDebug = conf.debug
let Character_ID = null
let PacketTemp = null

function OnJoin(data) {
    if (data !== null) {
        $.each(data, function (index, value) {
            $("#Row").prepend('<a id="' + value.Character_ID + '" class="Character tooltip" onclick="Selected(' + index + ')"><img src="'+value.Photo+'"/><span class="tooltiptext">' + value.First_Name + ' ' + value.Last_Name + '</span></a>');
        });
    }
};

function OnAction(data) {
    if (data !== null) {
        $.each(data, function (index, value) {
            $('#' + value.Character_ID).remove();
        });
    }
};

function Selected(key) {
    if (key === 'New') {
        Character_ID = 'New'
        document.getElementById('name').innerText = 'Confirm to make a new character'
        document.getElementById('created').innerText = '-'
        document.getElementById('lastseen').innerText = '-'
        if (EnableDebug) {
            console.log('   -= ' + Character_ID + ' =-   ')
        }
    } else {
        Character_ID = PacketTemp[key].Character_ID
        if (EnableDebug) {
            console.log('   -= ' + Character_ID + ' =-   ')
        }
        let Created = PacketTemp[key].Created
        let First = PacketTemp[key].First_Name
        let Last = PacketTemp[key].Last_Name
        let Login = PacketTemp[key].Last_Seen
        document.getElementById('name').innerText = First + ' ' + Last;
        document.getElementById('created').innerText = new Date(Created).toISOString().slice(0, 19).replace('T', ' ')
        document.getElementById('lastseen').innerText = new Date(Login).toISOString().slice(0, 19).replace('T', ' ')
    }
};

function CharacterDelete() {
    $.post('https://ore/Client:Character:Delete', JSON.stringify({
        ID: Character_ID,
    }));
    $("#Sidebar").hide();
    $("#CharacterList").hide();
    OnAction(PacketTemp);
};

function CharacterJoin() {
    $.post('https://ore/Client:Character:Join', JSON.stringify({
        ID: Character_ID,
    }));
    $("#Sidebar").hide();
    $("#CharacterList").hide();
    OnAction(PacketTemp);
};

function CharacterMake() {
    // Prevent form from submitting 
    var fn = document.getElementById("FirstName").value;
    var ln = document.getElementById("LastName").value;
    var cm = document.getElementById("Height").value;
    var dob = document.getElementById("DateOfBirth").value;
    $.post('https://ore/Client:Character:Create', JSON.stringify({
        First_Name: fn,
        Last_Name: ln,
        Height: cm,
        Birth_Date: dob,
    }));
    $("#CharacterMake").hide();
    OnAction(PacketTemp);
};

function OnNotify(data){
    var text = data.text
    var style = data.style
    var fade = data.fade
    var element
    if (style == 'normal') {
      element = $('<div class="noty normal"></div>'); 
    } else if (style == 'success') {
      element = $('<div class="noty success"></div>');
    } else if (style == 'fail') {
      element = $('<div class="noty fail"></div>');
    } else if (style == 'error') {
      element = $('<div class="noty error"></div>'); 
    } else {
      element = $('<div class="noty normal"></div>');     
    };

    $('#Notify-Window').prepend(element);
    $(element).innerText(text);
    $(element).fadeIn(750);
    
    setTimeout(function(){
       $(element).fadeOut(fade-(fade / 2));
    }, fade / 2);
    
    setTimeout(function(){
        $('#Notify-Window').remove(element);
    }, fade + 10000);
  
};

$(document).ready(function () {
    $('#DateOfBirth').mask('00-00-0000', { clearIfNotMatch: true });
    $('#Height').mask('000', { clearIfNotMatch: true });
    window.onload = (e) => {
        window.addEventListener('message', (event) => {
            let data = event.data;
            switch (data.message) {
                case 'OnJoin':
                    if (EnableDebug) {
                        console.log('   -= Message = OnJoin =-   ')
                    }
                    $("#Sidebar").show();
                    $("#CharacterList").show();
                    $("#CharacterMake").hide();
                    PacketTemp = data.packet;
                    OnJoin(PacketTemp);
                    break;
                case 'OnNew':
                    if (EnableDebug) {
                        console.log('   -= Message = OnNew =-   ')
                    }
                    $("#Sidebar").hide();
                    $("#CharacterList").hide();
                    $("#CharacterMake").show();
                    break;
                case 'OnNotify':
                    if (EnableDebug) {
                        console.log('   -= Message = OnNotify =-   ')
                    }
                    $("#Notify-Window").show();
                    OnNotify(data.notify)
                    break;
                case 'default':
                    if (EnableDebug) {
                        console.log('   -= No Message =-   ')
                        console.log('   -= No Data =-   ')
                        console.log('   -= Action = Hide NUI =-   ')
                    }
                    break;
            }
        });
    };

    $('#CharacterMake').submit(function (e) {
        e.preventDefault();
    }).validate({
        rules: {
            FirstName: {
                minlength: 1,
                maxlength: 35,
                required: true
            },
            LastName: {
                minlength: 1,
                maxlength: 35,
                required: true
            },
            Height: {
                minlength: 3,
                maxlength: 3,
                required: true
            },
            DateOfBirth: {
                minlength: 10,
                maxlength: 10,
                required: true
            }
        },
        submitHandler: function (form) {
            form.submit();
            CharacterMake();
        }
    });

});
