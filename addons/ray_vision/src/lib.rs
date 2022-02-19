mod ray_vision_2d;

use gdnative::{
	prelude::*,
	api::{
		EditorPlugin,
		Resource,
		Script,
		Texture
	}
};

#[derive(NativeClass)]
#[inherit(EditorPlugin)]
struct RayVisionPlugin;

#[methods]
impl RayVisionPlugin {
	fn new(_owner: TRef<EditorPlugin>) -> Self {
		RayVisionPlugin
	}

	#[export]
	fn _enter_tree(&self, owner: TRef<EditorPlugin>) {
		let loader = ResourceLoader::godot_singleton();
		let script = loader.load("res://addons//ray_vision//ray_vision_2d.gdns", "Script", false).unwrap().cast::<Script>().unwrap();
		let texture = loader.load("res://addons//ray_vision//ray_vision_2d.gdns", "Texture", false).unwrap().cast::<Texture>().unwrap();

		owner.add_custom_type("RayVision2D", "Node2D", script, texture);
	}

	#[export]
	fn _exit_tree(&self, owner: TRef<EditorPlugin>) {
		owner.remove_custom_type("RayVision2D");
	}
}

fn init(handle: InitHandle) {
	handle.add_tool_class::<RayVisionPlugin>();
}

fn main() {
    println!("Hello, world!");
}
