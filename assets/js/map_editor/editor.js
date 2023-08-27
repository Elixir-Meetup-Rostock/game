// https://www.youtube.com/watch?v=IYgZMIB7_PM

const shallowCompare = (obj1, obj2) =>
	Object.keys(obj1).length === Object.keys(obj2).length &&
	Object.keys(obj1).every((key) => obj1[key] === obj2[key]);

export default class MapEditor {
	constructor(
		parentAPP,
		node,
		availableTiles,
		bottomLayer,
		topLayer,
		activeLayer
	) {
		this.log = true;

		this.tileSize = 16;

		this.parentAPP = parentAPP;

		this.bottomLayer = bottomLayer;
		this.topLayer = topLayer;

		this.canvas = node;
		this.context = this.canvas.getContext("2d");

		this.animationFrameId = undefined;

		this.availableTiles = availableTiles;

		this.selectedTileSprite = this.availableTiles[0];
		this.activeLayer = activeLayer;

		this.setupDrawingListeners();

		this.drawFrame();
	}

	setBottomLayer(bottomLayer) {
		this.bottomLayer = bottomLayer;
	}

	setTopLayer(topLayer) {
		this.topLayer = topLayer;
	}

	setActiveLayer(activeLayer) {
		this.activeLayer = activeLayer;
	}

	setSelectedTile(selectedTile) {
		let tileSprite = this.availableTiles[0];
		this.availableTiles.forEach((tile) => {
			if (tile.tile === selectedTile) {
				tileSprite = tile;
			}
		});

		this.selectedTileSprite = tileSprite;

		if (this.log)
			console.log("this.selectedTileSprite", this.selectedTileSprite);
	}

	clear() {
		if (this.log) console.log("clear");

		this.canvas.width = this.canvas.width; // clears the canvas
	}

	drawFrame() {
		if (this.log) console.log("drawFrame");

		if (this.animationFrameId) {
			cancelAnimationFrame(this.animationFrameId);
		}

		this.animationFrameId = window.requestAnimationFrame(() => {
			this.draw();
		});
	}

	draw() {
		if (this.log) console.log("draw");

		this.clear();

		this.drawBottomLayer();
		this.drawTopLayer();
	}

	drawBottomLayer() {
		if (this.log) console.log("drawBottomLayer");

		for (const [key, value] of Object.entries(this.bottomLayer)) {
			let [x, y] = key.split("-").map(Number);

			const image = new Image();
			image.src = value.src;

			this.context.drawImage(
				image,
				x * this.tileSize,
				y * this.tileSize,
				this.tileSize,
				this.tileSize
			);
		}
	}

	drawTopLayer() {
		if (this.log) console.log("drawTopLayer");

		for (const [key, value] of Object.entries(this.topLayer)) {
			let [x, y] = key.split("-").map(Number);

			const image = new Image();
			image.src = value.src;

			this.context.drawImage(
				image,
				x * this.tileSize,
				y * this.tileSize,
				this.tileSize,
				this.tileSize
			);
		}
	}

	setupDrawingListeners() {
		// remove all listeners
		this.canvas.removeEventListener("mousedown", this.handleMouseDown);
		this.canvas.removeEventListener("mouseup", this.handleMouseUp);
		this.canvas.removeEventListener("mouseleave", this.handleMouseLeave);
		this.canvas.removeEventListener("mousemove", this.handleMouseMove);

		// add listeners
		this.canvas.addEventListener("mousedown", this.handleMouseDown);
		this.canvas.addEventListener("mouseup", this.handleMouseUp);
		this.canvas.addEventListener("mouseleave", this.handleMouseLeave);
		this.canvas.addEventListener("mousemove", this.handleMouseMove);
	}

	handleMouseDown = (event) => {
		this.isMouseDown = true;
		this.handleMouseMove(event);
	};

	handleMouseUp = (event) => {
		this.isMouseDown = false;
	};

	handleMouseLeave = (event) => {
		this.isMouseDown = false;
	};

	handleMouseMove = (event) => {
		if (this.isMouseDown) {
			this.addTile(event);
		}
	};

	addTile = (mouseEvent) => {
		const bb = this.canvas.getBoundingClientRect();
		const x = Math.floor(
			((mouseEvent.clientX - bb.left) / bb.width) * this.canvas.width
		);
		const y = Math.floor(
			((mouseEvent.clientY - bb.top) / bb.height) * this.canvas.height
		);

		let clicked = [
			Math.floor(x / this.tileSize),
			Math.floor(y / this.tileSize),
		];

		let key = clicked[0] + "-" + clicked[1];
		let hasChanged = false;

		if (mouseEvent.shiftKey) {
			if (this.activeLayer === "bottom") delete this.bottomLayer[key];
			else if (this.activeLayer === "top") delete this.topLayer[key];
			hasChanged = true;
		} else {
			if (
				this.activeLayer === "bottom" &&
				(!this.bottomLayer[key] ||
					!shallowCompare(this.bottomLayer[key], this.selectedTileSprite))
			) {
				this.bottomLayer[key] = { ...this.selectedTileSprite };
				hasChanged = true;
			} else if (
				this.activeLayer === "top" &&
				(!this.topLayer[key] ||
					!shallowCompare(this.topLayer[key], this.selectedTileSprite))
			) {
				this.topLayer[key] = { ...this.selectedTileSprite };
				hasChanged = true;
			}
		}

		if (hasChanged) {
			this.parentAPP.pushEvent("map_updated", {
				bottom_layer: this.bottomLayer,
				top_layer: this.topLayer,
				active_layer: this.activeLayer,
			});
			this.drawFrame();
		}
	};
}
