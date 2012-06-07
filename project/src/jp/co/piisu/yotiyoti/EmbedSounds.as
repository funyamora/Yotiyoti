package jp.co.piisu.yotiyoti
{
	/**
	 * 埋め込みサウンドをまとめて設定しておくクラス
	 * @author koji
	 */
	public class EmbedSounds
	{
		[Embed(source='./resources/funya_thema.mp3')]
		public static var mp3FunyaThema:Class;
		
		[Embed(source='./resources/ifudodo.mp3')]
		public static var mp3Ifudodo:Class;
		
		[Embed(source='./resources/se/emotion_shock.mp3')]
		public static var mp3Shock:Class;
		
		[Embed(source='./resources/se/jumping.mp3')]
		public static var mp3jumping:Class;
		
		[Embed(source='./resources/se/sit.mp3')]
		public static var mp3sit:Class;
		
		[Embed(source='./resources/oo.mp3')]
		public static var mp3oo:Class;
		
		
		public function EmbedSounds()
		{
		}
		
	}
}