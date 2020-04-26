function startTS(tsURL, intro) {
    setInterval(refreshPartial, 1000);
    // Attempt to keep the modal from scrolling vertically
    // 300px is the approximate height of the modal, minus the video
    $('#talking-stick-video-preview').modal({backdrop: 'static', keyboard: false, show: true});
    var myGuid = TalkingStick.generateGUID();
    // Use the least-common-denominator, Rails API, for WebRTC setup
    var options = {
        url: tsURL,
        myGuid: myGuid,
    };
    var signalingEngine = new TalkingStick.RailsSignaling(options);

    var options = {
        guid: myGuid,
        roomUrl: tsURL,
        signalingEngine: signalingEngine,
        logLevel: 'trace',
    };
    TalkingStick.init(options);

    $('#talking-stick-connect').click(startSession);
    $(window).on('talking_stick.local_media_setup', function() {
        $('#talking-stick-preview-instructions').html(intro);
        $('#talking-stick-connect').attr('disabled', false);
    });
}

function startSession() {
    $('#talking-stick-localvideo').detach().appendTo('#talking-stick-localvideo-container');
    $('#talking-stick-localvideo').height('auto');
    // Gotta restart and re-mute the video after moving it
    $('#talking-stick-localvideo')[0].play();
    TalkingStick.connect();
}

function resizeVideos() {
    var videoCollection = $('#talking-stick-partnervideos video');
    var numVideos = videoCollection.length;
    var square = Math.sqrt(numVideos);
    if (!isInt(square)) {
        // Round up to the next square
        square = parseInt(square);
    }
    console.log(square);
    videoCollection.css('width', (100/square) + "%");
}

function cleanupPartner() {
    resizeVideos();
}

function isInt(value){
    if((parseFloat(value) == parseInt(value)) && !isNaN(value)){
        return true;
    } else {
        return false;
    }
}