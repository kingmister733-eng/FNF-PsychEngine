package backend;

import haxe.Json;

typedef VSliceNote = {
	var t:Float;
	var d:Int;
	var l:Float;
	@:optional var k:String;
}

class VSliceConverter
{
	/**
	 * Автоматически распознает формат официального V-Slice
	 */
	public static function isVSlice(rawJson:String):Bool
	{
		return rawJson.contains('"notes"') && (rawJson.contains('"t":') || rawJson.contains('"playData"') || rawJson.contains('"characters"'));
	}

	/**
	 * Переводит ноты V-Slice в понятный для Psych Engine формат на лету
	 */
	public static function convertToPsych(rawJson:String, bpm:Float):Dynamic
	{
		var data:Dynamic = Json.parse(rawJson);
		var vsliceNotes:Array<Dynamic> = [];

		if (data.notes != null)
		{
			if (Std.isOfType(data.notes, Array))
				vsliceNotes = data.notes;
			else if (Reflect.hasField(data.notes, "bf"))
				vsliceNotes = Reflect.field(data.notes, "bf");
		}

		var stepCrochet:Float = (60 / bpm) * 1000 / 4;
		var sectionDuration:Float = stepCrochet * 16;
		var sections:Array<Dynamic> = [];

		vsliceNotes.sort((a, b) -> Std.int(a.t - b.t));

		for (n in vsliceNotes)
		{
			var noteTime:Float = n.t;
			var noteData:Int = n.d;
			var sustain:Float = (n.l != null) ? n.l : 0.0;
			var noteType:String = (n.k != null) ? n.k : "";

			var secIndex:Int = Math.floor(noteTime / sectionDuration);

			while (sections.length <= secIndex)
			{
				sections.push({
					sectionNotes: [],
					lengthInSteps: 16,
					mustHitSection: true,
					bpm: bpm,
					changeBPM: false
				});
			}

			sections[secIndex].sectionNotes.push([noteTime, noteData, sustain, noteType]);
		}

		return {
			song: (data.song != null) ? data.song : "Converted Song",
			notes: sections,
			bpm: bpm,
			needsVoices: true,
			speed: 2.0,
			player1: 'bf',
			player2: 'dad',
			gfVersion: 'gf'
		};
	}
}