
$(document).ready(function () {
    var isMobile = false;
    var isiPhoneiPad = false;

    if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
        isMobile = true;
    }
    if (/iPhone|iPad|iPod/i.test(navigator.userAgent)) {
        isiPhoneiPad = true;
    }
    if (!isMobile) {
        jQuery(".user-profile a.user-profile-dropdown, .user-profile-dropdown-body").hover(function () {
            jQuery(".user-profile-dropdown-body").css('opacity', '1');
            jQuery(".user-profile-dropdown-body").css('visibility', 'visible');
        }, function () {
            jQuery(".user-profile-dropdown-body").css('opacity', '0');
            jQuery(".user-profile-dropdown-body").css('visibility', 'hidden');
        });
    }
    if (isiPhoneiPad) {
        jQuery(".video-wrapper").css('display', 'none');
    }

    jQuery(".user-profile a.user-profile-dropdown").click(function () {
        //$('.navbar-collapse').collapse('hide');

        if ($('.user-profile-dropdown-body').css('visibility') == 'visible') {
            jQuery(".user-profile-dropdown-body").css('opacity', '0');
            jQuery(".user-profile-dropdown-body").css('visibility', 'hidden');
        }
        else {
            jQuery(".user-profile-dropdown-body").css('opacity', '1');
            jQuery(".user-profile-dropdown-body").css('visibility', 'visible');

        }
    });

    /*==============================================================*/
    //Shrink nav on scroll - START CODE
    /*==============================================================*/

    if ($(window).scrollTop() > 10) {
        $('nav').addClass('shrink-nav');
    } else {
        $('nav').removeClass('shrink-nav');
    }
    /*==============================================================*/
    //Shrink nav on scroll - END CODE
    /*==============================================================*/

});

$(window).scroll(function () {
    if ($(window).scrollTop() > 10) {
        $('nav').addClass('shrink-nav');
    } else {
        $('nav').removeClass('shrink-nav');
    }
});