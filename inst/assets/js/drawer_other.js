/*-----------------------extend fabric js----------------------------*/
// add group object props
fabric.Group.prototype.toObject = (function(toObject) {
          return function() {
            return fabric.util.object.extend(toObject.call(this), {
              id: this.id,
              selectable: this.selectable,
              evented: this.evented
            });
          };
        })(fabric.Group.prototype.toObject);

/*---------------------------------- other ---------------------------------*/
// dropdown menu display
$(function(){
  $('.banner-items .dropdown-menu a').click(function(e){e.preventDefault()});
  $('.to-canvas li a').click(function(e){e.preventDefault()});
});

// add more event to jquery
(function ($) {
        $.each(['show', 'hide', 'fadeOut', 'fadeIn'], function (i, ev) {
            var el = $.fn[ev];
            $.fn[ev] = function () {
                var result = el.apply(this, arguments);
                result.promise().done(function () {
                    this.triggerHandler(ev, [result]);
                });
                return result;
            };
        });
  })(jQuery);


$(function () {
  $('[data-toggle="tooltip"]').tooltip();
});


// move spectrum conflicts from shinyWidgets
$(function() {
    $('[href="shinyWidgets/spectrum/spectrum.min.css"]').remove();
})

// save base64 to blob
// https://stackoverflow.com/questions/12168909/blob-from-dataurl
function dataURItoBlob(dataURI) {
  // convert base64 to raw binary data held in a string
  // doesn't handle URLEncoded DataURIs - see SO answer #6850276 for code that does this
  var byteString = atob(dataURI.split(',')[1]);

  // separate out the mime component
  var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]

  // write the bytes of the string to an ArrayBuffer
  var ab = new ArrayBuffer(byteString.length);

  // create a view into the buffer
  var ia = new Uint8Array(ab);

  // set the bytes of the buffer to the correct values
  for (var i = 0; i < byteString.length; i++) {
      ia[i] = byteString.charCodeAt(i);
  }

  // write the ArrayBuffer to a blob, and you're done
  var blob = new Blob([ab], {type: mimeString});
  return blob;

}


// user operating system
function getOS() {
  var userAgent = window.navigator.userAgent,
      platform = window.navigator.platform,
      macosPlatforms = ['Macintosh', 'MacIntel', 'MacPPC', 'Mac68K', 'darwin'],
      windowsPlatforms = ['Win32', 'Win64', 'Windows', 'WinCE'],
      iosPlatforms = ['iPhone', 'iPad', 'iPod'],
      os = null;

  if (macosPlatforms.indexOf(platform) !== -1) {
    os = 'Mac';
  } else if (iosPlatforms.indexOf(platform) !== -1) {
    os = 'iOS';
  } else if (windowsPlatforms.indexOf(platform) !== -1) {
    os = 'Windows';
  } else if (/Android/.test(userAgent)) {
    os = 'Android';
  } else if (!os && /Linux/.test(platform)) {
    os = 'Linux';
  }

  return os;
}
