"use strict";

let step = {
	x: 64.3,
	y: 64.28
}

let assets = {}
let miniMapOpen = true;
let canvas = document.getElementById('canvas');
canvas.width = window.innerWidth;
canvas.height = window.innerHeight;
let ctx = canvas.getContext('2d');
let player = { position:{x:126703.0,y:78276.5703125}, rotation:0 };
let mapScale = 1;
let lastRender = 0
let onDrag = false;
let lastCursorPosition;
let canvasScreenPosition = {x:0,y:0};
let playerMarker = null;
let textDrawList = [];

/*load assets*/
let mapImg = new Image();
let dynamicBlips = {};
let assetsCount = 0;

u(mapImg).on('load', () => loadAssets());
mapImg.src = 'OnsetMapLayout_latest.jpg';

const loadAssets = () => {
	for(let [k,v] of Object.entries(types)){
		let img = new Image();
		img.addEventListener('load', function(){
			let baseWidth = this.width;

			this.width = 40;
			this.height = this.width * baseWidth / this.height;

			assets[k] = this;
			assetsCount++;

			if(assetsCount === Object.keys(types).length){
				loadFinish();
			}
		});
		img.src = 'img/' + v.img;
	}
}

function loadFinish() {
	console.log("load finish")
	canvas.width = minimapWidth;
	canvas.height = minimapHeight;
	canvas.classList.add(miniMapClass);
	mapScale = baseScale;
	canvas.style.display = "block";
	window.requestAnimationFrame(loop);
}
/**************************************/

/* infinite loop */
function loop(timestamp) {
	lastRender = timestamp;
	drawMap();
	window.requestAnimationFrame(loop);
}
/********************************/

/* all Function for draw */
function drawMap() {
	/*for rotation*/
	let rotationAngle = Math.PI / 180 * (player.rotation);
	let convertedPos = {x:(player.position.x/step.x) * mapScale,y:(player.position.y/step.y) * mapScale};
	let originalPointAngle = Math.atan2(convertedPos.y, convertedPos.x);
	let rotatedTopLeftAngle = originalPointAngle + rotationAngle;
	let radius = Math.sqrt(convertedPos.x*convertedPos.x+convertedPos.y*convertedPos.y);
	let rx = radius*Math.cos(rotatedTopLeftAngle);
	let ry = radius*Math.sin(rotatedTopLeftAngle);
	/*clear canvas*/
	ctx.beginPath();
	ctx.clearRect(-10000, -20000, canvas.width*100, canvas.height*100)

	if (miniMapOpen){
		ctx.setTransform(1,0,0,1, (canvas.width/2 - rx), (canvas.height/playerScreenDividende - ry));
		ctx.rotate(rotationAngle)
		ctx.scale(mapScale, mapScale);
	} else {
		ctx.setTransform(1,0,0,1,canvas.width/2 - (canvasScreenPosition.x*mapScale), canvas.height/2 - (canvasScreenPosition.y * mapScale));
		ctx.scale(mapScale, mapScale);
	}
	
	ctx.drawImage(mapImg, -mapImg.width / 2, -mapImg.height / 2);
	drawAllBlips();
	drawText(textDrawList);
	drawCirclePlayer(player.position.x,player.position.y);
}

function drawCirclePlayer(x, y) {
	ctx.beginPath();
	ctx.arc((x/step.x), (y/step.y), 5, 0, 2 * Math.PI, false);
	ctx.stroke();
	ctx.fillStyle = 'black';
	ctx.fill();
}

function drawAllBlips(){
	let rotationAngle = Math.PI / 180 * (-player.rotation);
	let reverseScale = 1
	let savedTransform = ctx.getTransform();
	if(mapScale < 0.8){
		reverseScale = getReverseScale(0.7);
	}
	//config blips
	blips.forEach(blip => {
		let newWidth = (assets[blip.type].width * reverseScale);
		ctx.beginPath()
		if(miniMapOpen){
			ctx.translate((blip.pos.x / step.x),(blip.pos.y / step.y))
			ctx.rotate(rotationAngle)
			ctx.drawImage(assets[blip.type], 0 - (newWidth) / 2, 0 - (assets[blip.type].height / 2) * reverseScale, newWidth, assets[blip.type].height * reverseScale);
			ctx.setTransform(savedTransform)
		}
		else{
			ctx.drawImage(assets[blip.type],(blip.pos.x / step.x) - (newWidth) / 2,(blip.pos.y / step.y) - (assets[blip.type].height / 2) * reverseScale, newWidth, assets[blip.type].height * reverseScale);
		}
	});

	//dynamic blip
	for(let [k,v] of Object.entries(dynamicBlips)){
		let asset = assets[v.type]
		let newWidth = (asset.width * reverseScale);
		ctx.beginPath()
		if(miniMapOpen){
			ctx.translate((v.pos.x / step.x),(v.pos.y / step.y))
			ctx.rotate(rotationAngle)
			ctx.drawImage(asset,0 - newWidth / 2 ,0 - (asset.height * reverseScale) / 2, asset.width * reverseScale, asset.height * reverseScale);
			ctx.setTransform(savedTransform)
		}
		else{
			ctx.drawImage(asset,(v.pos.x / step.x) - (newWidth / 2) , (v.pos.y / step.y) - ((asset.height * reverseScale) / 2), asset.width * reverseScale, asset.height * reverseScale);
		}
	}

	//draw playerMarker (draw in bottom for more precision)
	if (playerMarker != null){
		let asset = assets["playerMarker"]
		let newWidth = (asset.width * reverseScale);
		ctx.beginPath()
		if(miniMapOpen){
			ctx.translate((playerMarker.pos.x / step.x),(playerMarker.pos.y / step.y))
			ctx.rotate(rotationAngle)
			ctx.drawImage(asset, 0 - newWidth / 2, 0 - (asset.height * reverseScale), asset.width * reverseScale, asset.height * reverseScale);
			ctx.setTransform(savedTransform)
		}
		else{
			ctx.drawImage(asset,(playerMarker.pos.x / step.x) - (newWidth / 2) , (playerMarker.pos.y / step.y) - (asset.height * reverseScale), asset.width * reverseScale, asset.height * reverseScale);
		}
	}
}

function dot(x,y,radius,fill){
  ctx.beginPath();
  ctx.arc(x,y,radius,0,Math.PI*2,false);
  ctx.closePath();
  ctx.fillStyle=fill;
  ctx.fill();
}

function drawText(list){
	list.forEach(text => {
		let reverseScale = 1.5;
		if(mapScale < 0.1){
			reverseScale = getReverseScale(1.4);
		}
		else if(mapScale < 0.8){
			reverseScale = getReverseScale(0.7);
		}
		let height = 10 * reverseScale;
		ctx.font = height + "px Arial";
		let sizeOfText = ctx.measureText(text.content);
		ctx.fillStyle = 'black';
		ctx.fillRect((text.pos.x / step.x) - (sizeOfText.width / 2) - 5,(text.pos.y / step.y) - text.margin.top - height, sizeOfText.width + 10, height + (2 * reverseScale));
		ctx.fillStyle = 'white';
		ctx.fillText(text.content, (text.pos.x / step.x) - (sizeOfText.width / 2),(text.pos.y / step.y) - text.margin.top);
	});
}

/*OTHER*/
function changePlayerPosition(x,y,rotation){
	player.rotation = -rotation;
	player.position.x = x;
	player.position.y = y;
}

function ShowFullScreenMap(){
	miniMapOpen = false;
	canvasScreenPosition.x = player.position.x / step.x;
	canvasScreenPosition.y = player.position.y / step.y;
	canvas.width = window.innerWidth;
	canvas.height = window.innerHeight;
	canvas.classList.remove(miniMapClass);
}

function returnToMiniMap() {
	miniMapOpen = true;
	mapScale = baseScale;
	canvas.width = minimapWidth;
	canvas.height = minimapHeight;
	canvas.classList.add(miniMapClass);
}

function getReverseScale(mult) {
	return ((1 - mapScale) * 10) * mult;
}

/*function for get cursor position in canvas*/
function getCursorPosition(canvas, event) {
    const rect = canvas.getBoundingClientRect()
    const x = event.clientX - rect.left;
	const y = event.clientY - rect.top;
	return {x:x,y:y}
}


/*function for call in lua*/
function createBlip(uniqueIdentifier,type,pos){
	if(assets[type] !== undefined){
		dynamicBlips[uniqueIdentifier] = {
			type:type,
			pos:pos
		}
	}
}

function removeBlip(identifier){
	if(dynamicBlips[identifier] != undefined){
		delete dynamicBlips[identifier];
	}
}

/*Event*/
/*window.addEventListener("wheel", function(event) {
	if(!miniMapOpen){
		let delta = Math.sign(event.deltaY);
		let newScale = mapScale - (delta/20);
		if(delta == 1 && mapScale >= 0.1){
			mapScale = newScale
		}
		else if(delta == -1){
			mapScale = newScale
		}
	}
});*/

u(window).on('wheel', function (e) {
	if (!miniMapOpen) {
		let delta = Math.sign(e.deltaY);
		let newScale = mapScale - (delta/20);
		if(delta == 1 && mapScale >= 0.1){
			mapScale = newScale
		}
		else if(delta == -1){
			mapScale = newScale
		}
	}
});

u(canvas).on('mousedown', function (e) {
	if (e.button == 0){//left click
		lastCursorPosition = getCursorPosition(canvas,e);
		onDrag = true
	}
	else if(e.button == 2){//create or remove player marker
		let transform = ctx.getTransform();
		let pos = getCursorPosition(canvas, e)
		let x = ((pos.x - transform.e) * step.x) / mapScale;
		let y = ((pos.y - transform.f) * step.y) / mapScale;
		if(playerMarker != null){
			playerMarker = null;
		}
		else{
			playerMarker = {type:"playerMarker",pos:{x:x, y:y}};
		}
	}
});

/*canvas.addEventListener('mousedown', function(e) {
	if (e.button == 0){//left click
		lastCursorPosition = getCursorPosition(canvas,e);
		onDrag = true
	}
	else if(e.button == 2){//create or remove player marker
		let transform = ctx.getTransform();
		let pos = getCursorPosition(canvas, e)
		let x = ((pos.x - transform.e) * step.x) / mapScale;
		let y = ((pos.y - transform.f) * step.y) / mapScale;
		if(playerMarker != null){
			playerMarker = null;
		}
		else{
			playerMarker = {type:"playerMarker",pos:{x:x, y:y}};
		}
	}

})*/

//remove right click (for navigator)
//document.addEventListener('contextmenu', event => event.preventDefault()); 
u(document).on('contextmenu', e => e.preventDefault());

/*canvas.addEventListener('mouseup', function(e) {
	if (e.button == 0){
		onDrag = false
	}
})*/

u(canvas).on('mouseup', function (e) {
	if (e.button === 0) {
		onDrag = false;
	}
});

u(canvas).on('onmousemove', function (event) {
	if(onDrag && !miniMapOpen){
		let newPosition = getCursorPosition(canvas,event);
		let speed = 1
		if(mapScale < 0.8){
			speed = ((1 - mapScale) * 10) / 2;
		}
		canvasScreenPosition.x = canvasScreenPosition.x + ((lastCursorPosition.x - newPosition.x) * speed)
		canvasScreenPosition.y = canvasScreenPosition.y + ((lastCursorPosition.y - newPosition.y) * speed)
		lastCursorPosition = getCursorPosition(canvas,event);
	}

	//for detect if mouse on blip
	if(!miniMapOpen){
		let transform = ctx.getTransform();
		let cursorPos = getCursorPosition(canvas, event)
		let reverseScale = 1;
		let legend = [];
		let cursorPosCanvas = {x:cursorPos.x - transform.e,y:cursorPos.y - transform.f};
		if(mapScale < 0.8){
			reverseScale = getReverseScale(0.7);
		}
		blips.forEach(blip => {
			let zone = {
				min:{
					x:((blip.pos.x / step.x)) * mapScale - (((assets[blip.type].width / 2) * mapScale) * reverseScale),
					y:((blip.pos.y / step.y)) * mapScale - (((assets[blip.type].height / 2) * mapScale) * reverseScale)
				},
				max:{
					x:((blip.pos.x / step.x)) * mapScale + (((assets[blip.type].width / 2) * mapScale) * reverseScale),
					y:((blip.pos.y / step.y)) * mapScale + (((assets[blip.type].height / 2) * mapScale) * reverseScale)
				}
			}
			if(zone.max.x > cursorPosCanvas.x && zone.min.x < cursorPosCanvas.x && zone.max.y > cursorPosCanvas.y && zone.min.y < cursorPosCanvas.y){
				legend.push({
					pos:{
						x:blip.pos.x,
						y:blip.pos.y
					},
					margin:{
						top:(((assets[blip.type].height / 2)) * reverseScale),
						left:(((assets[blip.type].width / 2)) * reverseScale)
					},
					content: types[blip.type].name
				});
			}
		});

		for(let [k,v] of Object.entries(dynamicBlips)) {
			let zone = {
				min:{
					x:((v.pos.x / step.x)) * mapScale - (((assets[v.type].width / 2) * mapScale) * reverseScale),
					y:((v.pos.y / step.y)) * mapScale - (((assets[v.type].height / 2) * mapScale) * reverseScale)
				},
				max:{
					x:((v.pos.x / step.x)) * mapScale + (((assets[v.type].width / 2) * mapScale) * reverseScale),
					y:((v.pos.y / step.y)) * mapScale + (((assets[v.type].height / 2) * mapScale) * reverseScale)
				}
			}
			if(zone.max.x > cursorPosCanvas.x && zone.min.x < cursorPosCanvas.x && zone.max.y > cursorPosCanvas.y && zone.min.y < cursorPosCanvas.y){
				legend.push({
					pos:{
						x:v.pos.x,
						y:v.pos.y
					},
					margin:{
						top:(((assets[v.type].height / 2)) * reverseScale),
						left:(((assets[v.type].width / 2)) * reverseScale)
					},
					content: types[v.type].name
				});
			}
		}
		textDrawList = legend;
	}
});

const switchMap = () => {
	if(miniMapOpen) {
		if(typeof(ue) !== 'undefined'){
			ue.game.callevent("onsetMap:focus", []);
		}
		ShowFullScreenMap();
	}
	else {
		returnToMiniMap();
		if(typeof ue !== 'undefined'){
			ue.game.callevent("onsetMap:unfocus", []);
		}
		textDrawList = [];
	}
}

if (typeof(ue) === 'undefined'){
	u(window).on('onkeydown', function (e) {
		if(e.key == "m"){
			switchMap()
		}
	});
}