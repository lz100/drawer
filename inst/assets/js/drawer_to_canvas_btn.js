/*-----------------------send to canvas buttons----------------------------*/
function toCanvas(dom, canvasID){
  var imgBox = document.querySelector(`#img-box-${canvasID}`);
  if(imgBox === null) {
    toastr.error(`Canvas not found`, "", {positionClass: "toast-bottom-right", timeOut: 3500});
    throw new Error("Canvas not found");
  }
  try {
    var node = document.querySelector(dom);
  } catch(err) {
    toastr.error(`{${dom}} is not a valid selector`, "", {positionClass: "toast-bottom-right", timeOut: 3500});
    throw new Error(err.message);
  }
  if (!node) {
    toastr.error(`Target DOM {${dom}} not found`, "", {positionClass: "toast-bottom-right", timeOut: 3500});
    throw new Error(`Target DOM {${dom}} not found`);
  }
  domtoimage.toPng(node)
    .then(function (dataUrl) {
        var img = new Image(125, 125);
        img.draggable = true;
        img.draggable = true;
        img.src = dataUrl;
        imgBox.appendChild(img);
        $(`#img-box-${canvasID}`).trigger("img-added");
        toastr.success(`Sceenshot of {${dom}} sent`, "", {positionClass: "toast-bottom-right", timeOut: 2000});
    })
    .catch(function (error) {
      toastr.error(`Error ${error}`, "", {positionClass: "toast-bottom-right", timeOut: 3500});
      console.error('something went wrong!', error);
    });
}

function toPng(dom){
  var node = document.querySelector(dom);
  domtoimage.toBlob(node)
    .then(function (blob) {
        window.saveAs(blob, 'shinydraw.png');
  });
}

function toJpg(dom){
  var node = document.querySelector(dom);
  domtoimage.toJpeg(node, { quality: 1 })
    .then(function (dataUrl) {
        var link = document.createElement('a');
        link.download = 'shinydraw.jpeg';
        link.href = dataUrl;
        link.click();
    });
}

function toSvg(dom){
  var node = document.querySelector(dom);
  domtoimage.toSvg(node)
    .then(function (dataUrl) {
        var link = document.createElement('a');
        link.download = 'shinydraw.svg';
        link.href = dataUrl;
        link.click();
    });
}

$(function(){
  $('.btn.to-canvas').click(function(){
    var dom = $(this).parent().siblings().find('input[type="text"]').val();
    if(dom) {
      toCanvas(dom, $(this).attr('for'));
    }
  });
});
