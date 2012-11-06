package jp.nyatla.nyartoolkit.as3.markersystem 
{
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	/**
	 * 管理システムの発行するイベントを処理するインタフェイスです。
	 */
	public interface INyARSingleCameraSystemObserver
	{
		/**
		 * カメラパラメータが更新されたことを通知します。
		 * @param i_param
		 * @param i_near
		 * @param i_far
		 */
		function onUpdateCameraParametor(i_param:NyARParam,i_near:Number,i_far:Number):void
	}
}
