/*-----------------------handle drag upload files----------------------------*/
function canvasLoadImg(img, dropEvent, offsetX, offsetY){
  var setImageWidth = 100, setImageHeight = 100;
  var zoomScale = this.zoomScale;
  var zoomX = this.zoomX;
  var zoomY = this.zoomY;
  var cheight = this.canvas.getHeight();
  var cwidth = this.canvas.getWidth();
  var newImage = new fabric.Image(img, {
      width: img.naturalWidth,
      height: img.naturalHeight,
      scaleX: setImageWidth/img.naturalWidth * zoomScale,
      scaleY: setImageHeight/img.naturalHeight * zoomScale,
      // Set the center of the new object based on the event coordinates relative
      // to the canvas container.
      left: zoomX + (dropEvent.layerX - setImageWidth/2 + offsetX) * zoomScale,
      top: zoomY + (dropEvent.layerY - setImageHeight/2 + offsetY) * zoomScale
  });
  this.canvas.add(newImage);
  this.canvas.requestRenderAll();
}


function handleDragUpload(files, canvasID, dropEvent, that){
  // add offset if more than 1 img uploaded, prevent stack
  var offsetX = 0, offsetY = 0;
  ([...files]).forEach(file => {
    var img;
    let reader = new FileReader();
    // find progress bar and reset
    let progressEl = $(`#${canvasID}-progress .progress-bar`);
    let progressContainer = progressEl.parent().parent();
    //console.log(file);
    progressEl.css('width', `0%`);
    progressContainer.find('label').text(file.name);
    progressContainer.fadeIn(1000);

    if(file.type.startsWith("image/")){
      if(['tiff','vnd.adobe.photoshop'].some(e=>{return file.type.includes(e)})) {
        progressContainer.fadeOut(1000);
        toastr.error(`{${file.type}} file is not supported`, "", {positionClass: "toast-bottom-right", timeOut: 3500});
        throw new Error(`{${file.type}} file is not supported`);
      }
      reader.readAsDataURL(file);
      // after reading done;
      reader.onload = () =>{
        // create image
        img = new Image(125, 125);
        img.draggable = true;
        img.src = reader.result;
        // find canvas
        var imgBox = document.querySelector(`#img-box-${canvasID}`);
        if(imgBox === null) {
          toastr.error(`Canvas not found`, "", {positionClass: "toast-bottom-right", timeOut: 3500});
          throw new Error("Canvas not found");
        }
        // add img
        imgBox.appendChild(img);
        $(`#img-box-${canvasID}`).trigger("img-added");
        progressContainer.fadeOut(400);
        setTimeout(() => {
          canvasLoadImg.bind(that)(img, dropEvent, offsetX, offsetY);
          toastr.success(`File {${file.name}} loaded`, "", {positionClass: "toast-bottom-right", timeOut: 2000});
          offsetX += 20;
          offsetY += 20;
        }, 500);
      }
      // if error
      reader.error = (e) => {
        progressContainer.fadeOut(1000);
        toastr.error(`Cannot upload the file: ${reader.error}`, "", {positionClass: "toast-bottom-right", timeOut: 3500});
        throw new Error("drawR drag upload error");
      }
      // on progress
      reader.onprogress = function(data) {
        if (data.lengthComputable) {
          var progress = parseInt( ((data.loaded / data.total) * 100), 10 );
          progressEl.css('width', `${progress}%`)
        }
      }
    } else {
      progressContainer.fadeOut(1000);
      toastr.error(
        `File type {${file.type}} cannot be read`,
        "",
        {positionClass: "toast-bottom-right", timeOut: 3500}
      );
      throw new Error(`File type {${file.type}} cannot be read`);
    }
  })
}
