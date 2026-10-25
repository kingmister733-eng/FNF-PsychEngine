package backend;

import flixel.system.FlxAssets.FlxShader;

class AndroidShaderFix
{
	/**
	 * Адаптирует код шейдера под мобильный OpenGL ES
	 */
	public static function fixShaderSource(glsl:String):String
	{
		#if mobile
		var header:String = "#ifdef GL_ES\nprecision highp float;\nprecision mediump int;\n#endif\n";
		
		// Если точность еще не объявлена — добавляем в самое начало
		if (!glsl.contains("precision"))
		{
			glsl = header + glsl;
		}

		// Заменяем старые функции шейдеров на совместимые с Android
		glsl = StringTools.replace(glsl, "texture2D(", "texture(");
		glsl = StringTools.replace(glsl, "gl_FragColor", "fragColor");
		#end

		return glsl;
	}
}