
/*-----------------------canvas class and methods----------------------------*/
var Drawer = {};
Drawer.canvasInit = {};

class drawer {
  constructor(canvasID, height='default', width='default', startZoom=2) {
    this.canvasID = canvasID;
    this.canvasContainer = document.getElementById(`canvas-container-${this.canvasID}`);
    this.canvasContainer.canvasID = this.canvasID;

    //split panel
    this.canvasSplit();
    // start canvas
    if(height == "default") height = this.canvasContainer.offsetHeight;
    if(width == "default") width = this.canvasContainer.offsetWidth;
    this.canvasContainer.init = {};
    this.canvasContainer.init.w = width - 10;
    this.canvasContainer.init.h =  height - 15;

    this.canvasContainer.canvas = new fabric.Canvas(`canvas-f-${this.canvasID}`, {
      width: this.canvasContainer.init.w,
      height: this.canvasContainer.init.h,
      imageSmoothingEnabled: false,
      preserveObjectStacking: true
    });
    // background canvas
    this.canvasContainer.canvasb = new fabric.Canvas(`canvas-b-${this.canvasID}`, {
      width: this.canvasContainer.init.w,
      height: this.canvasContainer.init.h,
      imageSmoothingEnabled: false,
      preserveObjectStacking: true,
      selection: false,
      backgroundColor: "white"
    });
    $("canvas[id*='canvas-b-']").parent().css('z-index', '9'); // move bg canvas to back and re z-index
    $("canvas[id*='canvas-f-']").parent().css('z-index', '10');

    // watch canvas resize
    this.canvasResizer();
    // creatge frame
    this.creatgeFrame();
    // creatge grid
    this.createGrid();
    // start with 2x zoom
    //this.canvasContainer.canvas.zoomToPoint({ x: this.canvasContainer.offsetWidth/2, y: this.canvasContainer.offsetHeight/2 }, startZoom);
    //this.canvasContainer.canvasb.zoomToPoint({ x: this.canvasContainer.offsetWidth/2, y: this.canvasContainer.offsetHeight/2 }, startZoom);
    // limit movement
    this.limitMove();
    // delete event
    this.watchDel();


    // find images
    var dragWeb = false; // a flag indicating img drag is from web not uploaded
    this.imgs = document.querySelectorAll(`#img-box-${this.canvasID} img`);
    [].forEach.call(this.imgs, function(img) {
      img.addEventListener('dragstart',  this.handleDragStart, false);
      img.addEventListener('dragend', this.handleDragEnd, false);
    }.bind(this));
    //bind new imgs
    $(`#img-box-${this.canvasID}`).on( "img-added", function(){
      let img = $(`#img-box-${this.canvasID} img`).last().get(0);
      img.addEventListener('dragstart',  this.handleDragStart, false);
      img.addEventListener('dragend', this.handleDragEnd, false);
    }.bind(this));

    // Bind the event listeners for the canvas
    this.canvasContainer.addEventListener('dragenter', this.handleDragEnter, false);
    this.canvasContainer.addEventListener('dragover', this.handleDragOver, false);
    this.canvasContainer.addEventListener('dragleave', this.handleDragLeave, false);
    this.canvasContainer.addEventListener('drop', this.handleDrop, false);
    // zoom and panning
    this.canvasContainer.zoom = 1;
    this.canvasContainer.height = 1;
    this.canvasContainer.zoom = 1;
    this.canvasContainer.zoomX = 0;
    this.canvasContainer.zoomY = 0;
    this.canvasContainer.zoomCenterX = this.canvasContainer.init.w/2;
    this.canvasContainer.zoomCenterY = this.canvasContainer.init.h/2;
    this.canvasContainer.zoomScale = 1;
    this.canvasZoom();

    // user options
    this.opts = new Proxy({
      grid: false,
      frame: false,
      boundBox: false,
      objInfo: false,
      limitMove: false
    }, {
      set: this.updateOpts.bind(this)
    });
    this.updateOptInit();

    // init color pickers
    this.colors = {
      itextFill: "",
      itextBg: ""
    };
    this.colorInit();

    // init clipboard
    this.clipboard = undefined;

    //watch undo redo
    this.watchUndoRedo();

    //watch keys
    this.watchKeys();

  }

  //set up canvas zoom and panning
  canvasZoom(){
    this.canvasContainer.canvas.on('mouse:wheel', function(opt) {
      var delta = opt.e.deltaY;
      var zoom =  this.canvasContainer.canvas.getZoom();
      var canvas = this.canvasContainer.canvas;
      var canvasb = this.canvasContainer.canvasb;

      zoom *= 0.999 ** delta;
      if (zoom > 5) zoom = 5;
      if (zoom < 0.4) zoom = 0.4;
      canvas.zoomToPoint({ x: opt.e.offsetX, y: opt.e.offsetY }, zoom);
      canvasb.zoomToPoint({ x: opt.e.offsetX, y: opt.e.offsetY }, zoom);
      // console.log(opt.e)
      opt.e.preventDefault();
      opt.e.stopPropagation();
      //console.log(zoom);
      //console.log(this.canvasContainer.canvas.viewportTransform[4], this.canvasContainer.canvas.viewportTransform[5]);
      var vpt = canvas.viewportTransform;
      var vptb = canvasb.viewportTransform;
        if (zoom < 1) {
          vpt[4] = canvas.getWidth() * (1 - zoom) / 2;
          vptb[4] = canvas.getWidth() * (1 - zoom) / 2;
          vpt[5] = canvas.getHeight() * (1 - zoom) / 2;
          vptb[5] = canvas.getHeight() * (1 - zoom) / 2;
        }
      var transMatrix = fabric.util.invertTransform(vpt);
      // console.log(transMatrix[4], transMatrix[5]);
      this.canvasContainer.zoom = zoom;
      this.canvasContainer.zoomX = transMatrix[4];
      this.canvasContainer.zoomY = transMatrix[5];
      this.canvasContainer.zoomScale = transMatrix[0];
      this.canvasContainer.zoomCenterX = transMatrix[4] + this.canvasContainer.init.w/2 * transMatrix[0];
      this.canvasContainer.zoomCenterY = transMatrix[5] + this.canvasContainer.init.h/2 * transMatrix[0];
    }.bind(this));

    this.canvasContainer.canvas.on('mouse:down', function(opt) {
      var evt = opt.e;
      if (evt.altKey === true) {
        this.isDragging = true;
        this.selection = false;
        this.lastPosX = evt.clientX;
        this.lastPosY = evt.clientY;
      }
    });

    this.canvasContainer.canvas.on('mouse:move', function(opt) {
      var canvas = this.canvasContainer.canvas;
      var canvasb = this.canvasContainer.canvasb;
        if (canvas.isDragging) {
          var e = opt.e;
          var zoom = canvas.getZoom();
          var vpt  = canvas.viewportTransform;
          var vptb  = canvas.viewportTransform;
          if (zoom < 1) {
            vpt[4] = canvas.getWidth() * (1 - zoom) / 2;
            vptb[4] = canvas.getWidth() * (1 - zoom) / 2;
            vpt[5] = canvas.getHeight() * (1 - zoom) / 2;
            vptb[5] = canvas.getHeight() * (1 - zoom) / 2;
          }
          //if (zoom < 1) {
          //  vpt[4] = 200 - 1000 * zoom / 2;
          //  vpt[5] = 200 - 1000 * zoom / 2;
          else {
            vpt[4] += e.clientX - canvas.lastPosX;
            vptb[4] += e.clientX - canvas.lastPosX;
            vpt[5] += e.clientY - canvas.lastPosY;
            vptb[5] += e.clientY - canvas.lastPosY;
            if (vpt[4] >= 0) {
              vpt[4] = 0;
              vptb[4] = 0;
            } else if (vpt[4] < canvas.getWidth() * (1 - zoom)) {
              vpt[4] = canvas.getWidth() * (1 - zoom);
              vptb[4] = canvas.getWidth() * (1 - zoom);
            }
            if (vpt[5] >= 0) {
              vpt[5] = 0;
              vptb[5] = 0;
            } else if (vpt[5] < canvas.getHeight() * (1 - zoom)) {
              vpt[5] = canvas.getHeight() * (1 - zoom);
              vptb[5] = canvas.getHeight() * (1 - zoom);
            }
          }
          canvas.requestRenderAll();
          canvasb.requestRenderAll();
          canvas.lastPosX = e.clientX;
          canvasb.lastPosX = e.clientX;
          canvas.lastPosY = e.clientY;
          canvasb.lastPosY = e.clientY;
        }
    }.bind(this));

    this.canvasContainer.canvas.on('mouse:up', function(opt) {
      // on mouse up we want to recalculate new interaction
      // for all objects, so we call setViewportTransform
      this.canvasContainer.canvas.setViewportTransform(this.canvasContainer.canvas.viewportTransform);
      this.canvasContainer.canvasb.setViewportTransform(this.canvasContainer.canvas.viewportTransform);
      this.canvasContainer.canvas.isDragging = false;
      this.canvasContainer.canvas.selection = true;
      //update view Point
      var transMatrix = fabric.util.invertTransform(this.canvasContainer.canvas.viewportTransform);
      this.canvasContainer.zoomX = transMatrix[4];
      this.canvasContainer.zoomY = transMatrix[5];
      this.canvasContainer.zoomCenterX = transMatrix[4] + this.canvasContainer.init.w/2 * transMatrix[0];
      this.canvasContainer.zoomCenterY = transMatrix[5] + this.canvasContainer.init.h/2 * transMatrix[0];
    }.bind(this));
  }

  // creatge grid and frame
  creatgeFrame(){
    this.canvasContainer.frameBox = new fabric.Rect({
      width: this.canvasContainer.init.w,
      height: this.canvasContainer.init.h,
      evented: false,
      selectable: false,
      fill: '',
      stroke: '#cbcbcb'
    });
  }

  //creatge grid
  createGrid(){
      var gridsize_minor = 25;
      var gridsize_major = 50;
      var canvas = this.canvasContainer.canvas;
      var gridH = this.canvasContainer.init.h;
      var gridW = this.canvasContainer.init.w;
      var lines = [];
      //vertical
      for(var x=1;x<(gridW / gridsize_minor);x++){
        lines.push(new fabric.Line([gridsize_minor*x, 0, gridsize_minor*x, gridH],{
          stroke: "#eee", strokeWidth: 1
        }));
      }
      for(var x=1;x<(gridW/gridsize_major);x++){
        lines.push(new fabric.Line([gridsize_major*x, 0, gridsize_major*x, gridH],{
          stroke: "#ccc", strokeWidth: 1
        }));
      }
      // horizontal
      for(var x=1;x<(gridH/gridsize_minor);x++){
        lines.push(new fabric.Line([0, gridsize_minor*x, gridW, gridsize_minor*x],{
          stroke: "#eee", strokeWidth: 1
        }));
      }
      for(var x=1;x<(gridH/gridsize_major);x++){
        lines.push(new fabric.Line([0, gridsize_major*x, gridW, gridsize_major*x],{
          stroke: "#ccc", strokeWidth: 1
        }));
      }
      this.canvasContainer.gridGroup = new fabric.Group(lines, {id: 'grid', left: 0, top: 0, selectable:false, evented: false});
    //this.canvasContainer.gridGroup = new fabric.Rect({
    //  width: this.canvasContainer.init.w,
    //  height: this.canvasContainer.init.h,
    //  evented: false,
    //  selectable: false,
    //  fill: new fabric.Pattern({ source: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAABHNCSVQICAgIfAhkiAAAAK5JREFUaIHt1NEJwjAUheFzSybIMs7iDo7jDm7iOHeF+mCFEvNgqZpD+T8ohNA2939JZOasA5hGD/AtRdJt9BA7naVnyHXwIHtcXotSa71/+NEkKZb1vHp+LTrryMzT+qWy4Yft4P+6JNozo3f21hAH3TkOc2sR4oYQN4S4IcQNIW4IcUOIG0LcEOKGEDeEuCHEDSFuCHFDiBtC3BDihhA3hLghZLBoNwgZ6C1Ckh5/AxUzTq8RFwAAAABJRU5ErkJggg==' }),
     // stroke: '#cbcbcb'});
  }

  // limit movement
  limitMove() {
    var canvas = this.canvasContainer.canvas;
    var gridW = this.canvasContainer.init.w;
    var gridH = this.canvasContainer.init.h;
    var canvasID = this.canvasID;

    canvas.on('after:render', function() {
        canvas.contextContainer.strokeStyle = '#555';
        canvas.contextContainer.font = '12px sans-serif';
        var ao = canvas.getActiveObject();
        if (ao) {
          var oc = ao.oCoords;
          var maxX = Math.max(oc.tl.x, oc.tr.x, oc.bl.x, oc.br.x);
          var minX = Math.min(oc.tl.x, oc.tr.x, oc.bl.x, oc.br.x);
          var maxY = Math.max(oc.tl.y, oc.tr.y, oc.bl.y, oc.br.y);
          var minY = Math.min(oc.tl.y, oc.tr.y, oc.bl.y, oc.br.y);
          if(Drawer[canvasID].opts.objInfo){
            // add width height
            canvas.contextContainer.strokeText(
              `W ${(ao.width * ao.scaleX).toFixed(2)} (${(ao.scaleX*100).toFixed(0)}%) H ${(ao.height * ao.scaleY).toFixed(2)} (${(ao.scaleY*100).toFixed(0)}%)`,
              minX,
              minY - 12
            );
            // add X Y
            canvas.contextContainer.strokeText(
              `X ${ao.aCoords.tl.x.toFixed(2)} Y ${ao.aCoords.tl.y.toFixed(1)}`,
              oc.tl.x - ((ao.angle > 270) ? 100 : 0),
              oc.tl.y + ((ao.angle >= 180 && ao.angle <= 270) ? 25 : 0)
            );
            // add angle
            canvas.contextContainer.strokeText(
              `${ao.angle.toFixed(1)} °`,
              (oc.tl.x + oc.tr.x)/2 + 35 * Math.cos((ao.angle-90)/180*Math.PI),
              (oc.tl.y + oc.tr.y)/2 - 35 * Math.cos(ao.angle/180*Math.PI)
            );
          }
          // add bound box and info
          if(Drawer[canvasID].opts.boundBox){
            var bound = ao.getBoundingRect();
            canvas.contextContainer.strokeRect(
              bound.left,
              bound.top,
              bound.width,
              bound.height
            );
            canvas.contextContainer.strokeText(
              `Bound W ${(maxX- minX).toFixed(2)}`,
              bound.left,
              bound.top + bound.height + 10
            );
            canvas.contextContainer.strokeText(
              `Bound H ${(maxY- minY).toFixed(2)}`,
              bound.left + bound.width,
              bound.top + bound.height/2 + 10
            );
          }
        }
    });

    //canvas.on('object:rotate', function(e) {
    //  var angle = e.target.angle;
    //  var obj = e.target;
    //  var ac = obj.aCoords;
    //  var dia = Math.sqrt(Math.pow(ac.br.x - ac.tl.x, 2) + Math.pow(ac.br.y - ac.tl.y, 2));
    //  var diaLeft, diaTop;
    //  if(0 <= angle && angle <= 135){
    //    diaLeft = dia * angle/135;
    //  } else if (135 < angle && angle <= 270) {
    //    diaLeft = dia * (1 - (angle -135)/135);
    //  } else if (angle > 270) {
    //    diaLeft = 0;
    //  }
    //  var sinx = Math.sin(2/3*(angle/180*Math.PI)) * dia
    //  console.log('raw_sin', Math.sin((angle/180*Math.PI)/(6/4)))
    //  console.log('dia', Math.round(dia), 'angle', angle)
    //  console.log('diaLeft', diaLeft)
    //  console.log('sinx', sinx)
    //});

    var calcPos = function(num, obj_h_w, grid_h_w, minVal){
      if (minVal < 0) {num -= minVal}
      if(num < 0){
        return 0;
      } else {
        return Math.min(grid_h_w - obj_h_w, num);
      }
    };

    canvas.on('object:moving', (e) => {
      if (!Drawer[canvasID].opts.limitMove) return true;
      //console.log(e.target);
      var angle = e.target.angle;
      var obj = e.target;
      var ac = obj.aCoords;
      //var bound = obj.getBoundingRect();
      var top, left;
      var maxX = Math.max(ac.tl.x, ac.tr.x, ac.bl.x, ac.br.x);
      var maxY = Math.max(ac.tl.y, ac.tr.y, ac.bl.y, ac.br.y);
      var dia = Math.sqrt(Math.pow(ac.br.x - ac.tl.x, 2) + Math.pow(ac.br.y - ac.tl.y, 2));
      // get diagonal to limit left and top
      var diaLeft, diaTop;
      if(0 <= angle && angle <= 270){
        diaLeft = Math.sin((angle/180*Math.PI)/(6/4)) * dia; // use sin to get smooth boundary
      } else if (angle > 270) {
        diaLeft = 0;
      }
      if(0 <= angle && angle <= 90){
        diaTop = 0;
      } else if (angle > 90) {
        diaTop = Math.sin(((angle - 90)/180*Math.PI)/(6/4)) * dia;
      }
      //console.log('dia', dia, 'angle', angle, 'diaLeft', diaLeft)
      // limit X
      if(obj.left <= diaLeft){
        left = diaLeft;
      } else if (obj.left > diaLeft){
        left = Math.min(gridW - (maxX - ac.tl.x), obj.left); // use coords to limit right and bot
      }
      // limit Y
      if(obj.top <= diaTop){
        top = diaTop;
      } else if (obj.top > diaTop){
        top = Math.min(gridH - (maxY - ac.tl.y), obj.top);
      }
      obj.set({
        top: top,
        left: left
      });
      obj.setCoords();
    });
  }

  // delete event
    // by button
  delItem(canvas=null) {
    if(canvas === null) {canvas = this.canvasContainer.canvas}
    let selected = canvas.getActiveObjects();
    if (!selected.isEditing) {
      canvas.remove(...selected);
    }
    canvas.discardActiveObject().renderAll();
  }
    // by key
  watchDel() {
    var canvas = this.canvasContainer.canvas;
    var delItem = this.delItem;
    $(this.canvasContainer).on('keydown', function (e) {
      const key = e.key;
      if (key == "Delete") {
        delItem(canvas);
      }
    });
  }

  /*
  In following handlers, this or e.target means this.canvasContainer,
  passed from constructor
  */
  // handle iamges
  handleDragStart(e) {
    e.dataTransfer.setData('text/plain', 'not_uploaded');
    $(`#img-box-${this.canvasID} img`).removeClass('drawer-canvas-img-dragging');
    this.classList.add('drawer-canvas-img-dragging');
  }

  handleDragEnd(e) {
    $(this).removeClass('drawer-canvas-img-dragging');
  }

  // handle canvas
  handleDragOver(e) {
    if (e.preventDefault) {
        e.preventDefault(); // Necessary. Allows us to drop.
    }
    //console.log('x', e.layerX);
    //console.log('y', e.layerY);
    e.dataTransfer.dropEffect = 'copy'; // See the section on the DataTransfer object.
    // NOTE: comment above refers to the article (see top) -natchiketa
    this.classList.add('drawer-canvas-over');
    return false;
  }

  handleDragEnter(e) {
    // not in use
  }

  handleDragLeave(e) {
    this.classList.remove('drawer-canvas-over');
  }

  handleDrop(e) {
    e.stopPropagation();
    e.preventDefault();
    var files = e.dataTransfer.files;
    //console.log(this)
    //console.log(files)
    //console.log(e.dataTransfer)
    //console.log(e.dataTransfer.getData("text/plain"))
    //console.log(files)
    if(e.dataTransfer.getData("text/plain") === "not_uploaded") {
      var img = document.querySelector(`#img-box-${this.canvasID} img.drawer-canvas-img-dragging`);
      canvasLoadImg.bind(this)(img, e, 0, 0);
    } else {
      handleDragUpload(files, this.canvasID, e, this);
    }
    this.classList.remove('drawer-canvas-over');
    return false;
  }

  //split canvas
  canvasSplit(){
    this.split = Split([`#canvas-left-${this.canvasID}`, `#canvas-container-${this.canvasID}`], {
      sizes: [20, 80],
      minSize: 10,
      gutterSize: 5
      });
  }

  // canvas resize
  canvasResizer() {
    var container = this.canvasContainer;
    var canvas = this.canvasContainer.canvas;
    var canvasb = this.canvasContainer.canvasb;
    var rb = new ResizeObserver(entries => {
      canvas.setHeight(container.offsetHeight);
      canvas.setWidth(container.offsetWidth);
      canvasb.setHeight(container.offsetHeight);
      canvasb.setWidth(container.offsetWidth);
    });
      rb.observe(this.canvasContainer);
  }

  // option update
  updateOptInit(){
    let canvasID = this.canvasID;
    let canvas = this.canvasContainer.canvas;

    $(function(){
      $(`#canvas-banner-${canvasID} .dropdown ul li`).map(function(a){
        let el = $(this);
        if(el.attr('check') == 'true' && el.attr('check') !== undefined){
          el.find('i').show();
          Drawer[canvasID].opts[el.attr('opt-id')] = true;
        }
      });
    });

    $(`#canvas-banner-${canvasID} .dropdown ul`).on('click', 'li', function(){
      let el = $(this);
      if(el.attr('check') == 'true'){
        el.attr('check', 'false');
        el.find('i').hide();
        Drawer[canvasID].opts[el.attr('opt-id')] = false;
      } else {
        el.attr('check', 'true');
        el.find('i').show();
        Drawer[canvasID].opts[el.attr('opt-id')] = true;
      }
    });
  }

  updateOpts(obj, key, value) {
    obj[key] = value;
    switch(key) {
      case 'grid':
        this.toggleGrid();
        break;
      case 'frame':
        this.toggleFrame();
        break;
      case 'objInfo':
        this.canvasContainer.canvas.requestRenderAll();
        break;
      case 'boundBox':
        this.canvasContainer.canvas.requestRenderAll();
        break;
      case 'limitMove':
        this.canvasContainer.canvas.requestRenderAll();
        break;
    }
    return true;
  }

  toggleGrid({notSaving=true}={}){
    if(this.opts.grid === true && notSaving){
      this.canvasContainer.canvasb.add(this.canvasContainer.gridGroup);
    } else {
      this.canvasContainer.canvasb.remove(this.canvasContainer.gridGroup);
    }
  }

  toggleFrame({notSaving=true}={}){
    if(this.opts.frame === true && notSaving){
      this.canvasContainer.canvasb.sendToBack(this.canvasContainer.frameBox);
    } else {
      this.canvasContainer.canvasb.remove(this.canvasContainer.frameBox);
    }
  }

  // color pickers
  colorInit(){
    var colorConfig = {
      type: "color",
      togglePaletteOnly: true,
      showInput: true,
      showInitial: true,
      showAlpha: false
    };
    var canvas = this.canvasContainer.canvas;
    var canvasID = this.canvasID;
    // text color pickers
    $(`#canvas-text-fill-${this.canvasID}`).spectrum(spectrumConfig(canvas, canvasID, 'itextFill', 'fill'));
    $(`#canvas-text-bg-${this.canvasID}`).spectrum(spectrumConfig(canvas, canvasID, 'itextBg', 'textBackgroundColor'));
    //$(`#canvas-text-bg-${this.canvasID}`).spectrum('set', '')

    //picker for
  }

  // copy cut paste
  copy(callBack = function(){}){
    var actobj = this.canvasContainer.canvas.getActiveObject();
    console.log(actobj);
    if (actobj) {
      // Clone
      actobj.clone((object) => {
          // save it
          this.clipboard = object;

          //If the callback method exists, call it
          if (callBack !== undefined) callBack();
      });
    }
    //console.log("copied")
  }

  cut(){
    var canvas = this.canvasContainer.canvas;
    this.copy(() => canvas.remove(canvas.getActiveObject()));
    //console.log("cut")
  }

  paste() {
    var canvas = this.canvasContainer.canvas;
      if (this.clipboard  !== undefined) {
        this.clipboard.clone((clonedObj) => {
          canvas.discardActiveObject();
          clonedObj.set({
      			left: clonedObj.left + 10,
      			top: clonedObj.top + 10,
      			evented: true,
      		});
          if (clonedObj.type === 'activeSelection') {
      			// active selection needs a reference to the canvas.
      			clonedObj.canvas = canvas;
      			clonedObj.forEachObject(function(obj) {
      				canvas.add(obj);
      			});
      			// this should solve the unselectability
      			clonedObj.setCoords();
      		} else {
      			canvas.add(clonedObj);
      		}
      		this.clipboard.top += 10;
  	    	this.clipboard.left += 10;
          canvas.setActiveObject(clonedObj);
          canvas.requestRenderAll();
        });
      }
      //console.log("paste")
  }

  // redo undo changes
  undo(){
    this.canvasContainer.canvas.undo();
  }

  redo(){
    this.canvasContainer.canvas.redo();
  }

  // redo undo listeners
  watchUndoRedo(){
    var canvasID = this.canvasID;
    var undoBtn = $(`#canvas-undo-${canvasID}`);
    var redoBtn = $(`#canvas-redo-${canvasID}`);

    function toggleReUndo(e){
      if(e.currentStep == 0) {
        undoBtn.prop('disabled', true);
        var tip = $(`.canvas-box *[disabled]`).next();
        if(tip.hasClass('tooltip')) tip.remove();
      } else {
        undoBtn.prop('disabled', false);
      }
      if(Drawer[canvasID].canvasContainer.canvas.historyCurrentStep == Drawer[canvasID].canvasContainer.canvas.history.length-1) {
        redoBtn.prop('disabled', true);
        var tip = $(`.canvas-box *[disabled]`).next();
        if(tip.hasClass('tooltip')) tip.remove();
      } else {
        redoBtn.prop('disabled', false);
      }
    }

    this.canvasContainer.canvas.on({
      'history:append': toggleReUndo,
      'history:undo': toggleReUndo,
      'history:redo': toggleReUndo
    });
  }

  // change layer (z index)
  toForward(){
    let canvas = this.canvasContainer.canvas;
    let selected = canvas.getActiveObjects();
    if(selected.length > 0){
      var i;
      for (i = selected.length; i--;) {
        canvas.bringForward(selected[i]);
      }
      canvas.requestRenderAll();
    }
  }

  toFront(){
    let canvas = this.canvasContainer.canvas;
    let selected = canvas.getActiveObjects();
    if(selected.length > 0){
      var i;
      for (i = selected.length; i--;) {
        canvas.bringToFront(selected[i]);
      }
      canvas.requestRenderAll();
    }
  }

  toBackward(){
    let canvas = this.canvasContainer.canvas;
    let selected = canvas.getActiveObjects();
    if(selected.length > 0){
      var i;
      for (i = selected.length; i--;) {
        canvas.sendBackwards(selected[i]);
      }
      canvas.requestRenderAll();
    }
  }

  toBack(){
    let canvas = this.canvasContainer.canvas;
    let selected = canvas.getActiveObjects();
    if(selected.length > 0){
      var i;
      for (i = selected.length; i--;) {
        canvas.sendToBack(selected[i]);
      }
      canvas.requestRenderAll();
    }
  }

  // opacity
  changeOpacity(opacity){
    var canvas = this.canvasContainer.canvas;
    var obj = canvas.getActiveObject();
    if (obj) {
      if(obj.type != "activeSelection"){
        obj.set({opacity: parseFloat(opacity)});
        canvas._historySaveAction();
        canvas.requestRenderAll();
      }
    }
  }

  // TODO angle
  //changeAngle(){
  //  var obj = canvas.getActiveObjects();
  //  if (obj){
  //    var isBold = decideStyle(getStyle(obj, 'fontWeight'), 'bold');
  //    setStyle(obj, 'fontWeight', isBold ? 'normal' : 'bold');
  //    obj.dirty = true;
  //    this.canvasContainer.canvas.requestRenderAll();
  //    this.canvasContainer.canvas._historySaveAction();
  //  }
  //}

  // iText
  newItext(){
    var iText = new fabric.IText('Tap and Type', {
      left: this.canvasContainer.zoomCenterX,
      top: this.canvasContainer.zoomCenterY,
      fontSize: 12,
      //fontFamily: 'Helvetica',
      //fill: this.colors.itextFill,
      //textBackgroundColor: this.colors.itextBg
    });

    this.canvasContainer.canvas.add(iText);
  }

  itextBold(){
    var obj = getType(this.canvasContainer.canvas, "i-text");
    if (obj){
      var isBold = decideStyle(getStyle(obj, 'fontWeight'), 'bold');
      setStyle(obj, 'fontWeight', isBold ? 'normal' : 'bold');
      obj.dirty = true;
      this.canvasContainer.canvas.requestRenderAll();
      this.canvasContainer.canvas._historySaveAction();
    }

  }

  itextItalic(){
    var obj = getType(this.canvasContainer.canvas, "i-text");
    if (obj){
      var isItalic = decideStyle(getStyle(obj, 'fontStyle'), 'italic');
      setStyle(obj, 'fontStyle', isItalic ? 'normal' : 'italic');
      obj.dirty = true;
      this.canvasContainer.canvas.requestRenderAll();
      this.canvasContainer.canvas._historySaveAction();
    }
  }

  itextUnderline(){
    var obj = getType(this.canvasContainer.canvas, "i-text");
    if (obj){
      var isUnderline = decideStyle(getStyle(obj, 'underline'), true);
      setStyle(obj, 'underline', isUnderline ? false : true);
      obj.dirty = true;
      this.canvasContainer.canvas.requestRenderAll();
      this.canvasContainer.canvas._historySaveAction();
    }
  }

  itextLinethrough(){
    var obj = getType(this.canvasContainer.canvas, "i-text");
    if (obj){
      var isLinethrough = decideStyle(getStyle(obj, 'linethrough'), true);
      setStyle(obj, 'linethrough', isLinethrough ? false : true);
      obj.dirty = true;
      this.canvasContainer.canvas.requestRenderAll();
      this.canvasContainer.canvas._historySaveAction();
    }
  }

  itextSuperScript() {
    var obj = getType(this.canvasContainer.canvas, "i-text");
    if (obj){
      if(obj.isEditing){
        obj.setSuperscript();
        obj.dirty = true;
        this.canvasContainer.canvas.requestRenderAll();
        this.canvasContainer.canvas._historySaveAction();
      }
    }
  }

  itextSubScript() {
    var obj = getType(this.canvasContainer.canvas, "i-text");
    if (obj){
      if(obj.isEditing){
        obj.setSubscript();
        obj.dirty = true;
        this.canvasContainer.canvas.requestRenderAll();
        this.canvasContainer.canvas._historySaveAction();
      }
    }
  }

  itextRemoveFormat() {
    var obj = getType(this.canvasContainer.canvas, "i-text");
    if (obj){
      if(obj.isEditing){
        obj.setSelectionStyles({
      		fontSize: undefined,
      		deltaY: undefined,
      	});
        this.canvasContainer.canvas.requestRenderAll();
        this.canvasContainer.canvas._historySaveAction();
      }
    }
  }

  // saving funcs
  saveAsImg(png=true){
    var zoom = this.canvasContainer.zoom,
        zoomX  = this.canvasContainer.zoomX,
        zoomY = this.canvasContainer.zoomY,
        canvas = this.canvasContainer.canvas,
        format = 'png';
    if(!png) {
      canvas.setBackgroundColor("white");
      format = 'jpeg';
    }
    if(!this.opts.limitMove || zoom >= 1){
      window.saveAs(dataURItoBlob(canvas.toDataURL({
        format: format
      })), `canvas.${format}`);
    } else {
      window.saveAs(dataURItoBlob(canvas.toDataURL({
        format: format,
        top: -zoomY*zoom,
        left: -zoomX*zoom,
        height: this.canvasContainer.init.h*zoom,
        width: this.canvasContainer.init.w*zoom
      })), `canvas.${format}`);
    }
    if(!png) canvas.setBackgroundColor("");
  }

  // key listeners
  watchKeys(){
    var isMac = getOS() == "Mac";
    this.canvasContainer.addEventListener('keydown', function(event){
      var isCtrl = isMac ? event.metaKey : event.ctrlKey;
      if(isCtrl) {
        if (!event.shiftKey && event.keyCode == 90) {
          this.undo(); //Undo - CTRL+ z
        } else if (event.shiftKey && event.keyCode == 90) {
          this.redo(); //Redo - CTRL+ shift + z
        } else if (event.keyCode == 67) {
          this.copy() //Copy - CTRL+ c
        } else if (event.keyCode == 88) {
          this.cut() //Cut - CTRL+ x
        } else if (event.keyCode == 86) {
          this.paste() //Paste - CTRL+ v
        }
      }
    }.bind(this));
    // avoid adding to document as much as possible
    document.addEventListener('keydown', function(event){
      var isCtrl = isMac ? event.metaKey : event.ctrlKey;
      if(isCtrl) {
        if (!event.shiftKey && event.keyCode == 66) {
          this.itextBold(); //bold - CTRL+b
        } else if (!event.shiftKey && event.keyCode == 73) {
          this.itextItalic(); //Redo - CTRL+i
        } else if (!event.shiftKey && event.keyCode == 190) {
          this.itextSuperScript(); //superscript - CTRL+ .
        } else if (event.shiftKey && event.keyCode == 190) {
          this.itextRemoveFormat(); //remove script - CTRL+ shift + .
        } else if (event.keyCode == 188) {
          this.itextSubScript(); //subscript - CTRL+ ,
        }
      }

    }.bind(this));
  }
}



/*-----------------------help funcs----------------------------*/
// fet fabric type
function getType(canvas, type){
  var obj = canvas.getActiveObject();
  if(obj){
    if(obj.type == type){
      return obj;
    } else {
      return false;
    }
  }
}

// get fabric obj style, mostly used for iText

function getStyle(object, styleName) {
  if(object.getSelectionStyles && object.isEditing){
    var style = object.getSelectionStyles();
    if(!style) return false;
    return style.map(function(i){return i[styleName]});
  } else if (object.setSelectionStyles) {
    object.setSelectionStart(0);
    object.setSelectionEnd(999);
    var style = object.getSelectionStyles();
    // console.log(style)
    return style.map(function(i){return i[styleName]});
  } else {
    return object[styleName];
  }
}

function decideStyle(style, value){
  if(!style) return false;
  if(Array.isArray(style)) {
    return style.every((e)=> e == value);
  } else {
    return style == value;
  }
}

function setStyle(object, styleName, value) {
  if (object.setSelectionStyles && object.isEditing) {
    var style = { };
    style[styleName] = value;
    object.setSelectionStyles(style);
  } else if (object.setSelectionStyles) {
    var style = { };
    style[styleName] = value;
    object.setSelectionStart(0);
    object.setSelectionEnd(99999);
    object.setSelectionStyles(style);
  } else {
    object[styleName] = value;
  }
}

function getAndSetStyle(canvas, type, style, value, save=false){
  var obj = getType(canvas, type);
  if (obj){
    setStyle(obj, style, value);
    obj.dirty = true;
    canvas.requestRenderAll();
    if (save) canvas._historySaveAction();
  }
}

// color picker config
function spectrumConfig(canvas, canvasID, colorID, style){
    return {
      type: "color",
      preferredFormat: "hex3",
      togglePaletteOnly: true,
      showInput: true,
      showInitial: true,
      showAlpha: false,
      allowEmpty: true,
      showPalette: true,
      showSelectionPalette: true,
      localStorageKey: "spectrum.drawer",
      maxSelectionSize: 16,
      appendTo: `#${canvasID}`,
      containerClassName: 'drawer-spec-container',
      palette: [
        ["#000","#444","#666","#999","#ccc","#eee","#f3f3f3","#fff"],
        ["#f00","#f90","#ff0","#0f0","#0ff","#00f","#90f","#f0f"],
        ["#f4cccc","#fce5cd","#fff2cc","#d9ead3","#d0e0e3","#cfe2f3","#d9d2e9","#ead1dc"],
        ["#ea9999","#f9cb9c","#ffe599","#b6d7a8","#a2c4c9","#9fc5e8","#b4a7d6","#d5a6bd"],
        ["#e06666","#f6b26b","#ffd966","#93c47d","#76a5af","#6fa8dc","#8e7cc3","#c27ba0"],
        ["#c00","#e69138","#f1c232","#6aa84f","#45818e","#3d85c6","#674ea7","#a64d79"],
        ["#900","#b45f06","#bf9000","#38761d","#134f5c","#0b5394","#351c75","#741b47"],
        ["#600","#783f04","#7f6000","#274e13","#0c343d","#073763","#20124d","#4c1130"]
      ],
      move: function(color){
        color = (color) ? color.toHexString() : "";
        getAndSetStyle(canvas, "i-text", style, color);
      },
      hide: function(color){
        color = Drawer[canvasID].colors[colorID];
        getAndSetStyle(canvas, "i-text", style, color);
      },
      change: function(color){
        color = (color) ? color.toHexString() : "";
        getAndSetStyle(canvas, "i-text", style, color, true);
        Drawer[canvasID].colors[colorID] = color;
      }
    };
}

