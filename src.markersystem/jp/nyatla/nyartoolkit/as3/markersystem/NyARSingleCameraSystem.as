package jp.nyatla.nyartoolkit.as3.markersystem
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	public class NyARSingleCameraSystem
	{
		/** 定数値。視錐台のFARパラメータの初期値[mm]です。*/
		public static const FRUSTUM_DEFAULT_FAR_CLIP:Number=10000;
		/** 定数値。視錐台のNEARパラメータの初期値[mm]です。*/
		public static const FRUSTUM_DEFAULT_NEAR_CLIP:Number=10;
		
		protected var _ref_param:NyARParam;
		protected var _frustum:NyARFrustum;	
		public function NyARSingleCameraSystem(i_ref_cparam:NyARParam)
		{
			this._observer=new ObserverList(3);
			this._ref_param=i_ref_cparam;
			this._frustum=new NyARFrustum();
			this.setProjectionMatrixClipping(FRUSTUM_DEFAULT_NEAR_CLIP, FRUSTUM_DEFAULT_FAR_CLIP);
			
		}
		/**
		 * [readonly]
		 * 現在のフラスタムオブジェクトを返します。
		 * @return
		 */
		public function getFrustum():NyARFrustum
		{
			return this._frustum;
		}
		/**
		 * [readonly]
		 * 現在のカメラパラメータオブジェクトを返します。
		 * @return
		 */
		public function getARParam():NyARParam
		{
			return this._ref_param;
		}
		/**
		 * 視錐台パラメータを設定します。
		 * この関数は、値を更新後、登録済の{@link IObserver}オブジェクトへ、{@link #EV_UPDATE}通知を送信します。
		 * @param i_near
		 * 新しいNEARパラメータ
		 * @param i_far
		 * 新しいFARパラメータ
		 */
		public function setProjectionMatrixClipping(i_near:Number,i_far:Number):void
		{
			var s:NyARIntSize=this._ref_param.getScreenSize();
			this._frustum.setValue_2(this._ref_param.getPerspectiveProjectionMatrix(),s.w,s.h,i_near,i_far);
			//イベントの通知
			this._observer.notifyOnUpdateCameraParametor(this._ref_param,i_near,i_far);
		}	
		
		

		protected var _observer:ObserverList;
		/**
		 * {@link NyARSingleCameraSystem}のイベント通知リストへオブザーバを追加します。
		 * この関数は、オブザーバが起動時に使用します。ユーザが使用することは余りありません。
		 * @param i_observer
		 * 通知先のオブザーバオブジェクト
		 */
		public function addObserver(i_observer:INyARSingleCameraSystemObserver):void
		{
			this._observer.pushAssert(i_observer);
			var f:NyARFrustum_FrustumParam=this.getFrustum().getFrustumParam(new NyARFrustum_FrustumParam());
			i_observer.onUpdateCameraParametor(this._ref_param, f.near, f.far);		
		}
	}
}
import jp.nyatla.nyartoolkit.as3.core.types.stack.*;
import jp.nyatla.nyartoolkit.as3.core.param.*;
//
//	イベント通知系
//
class ObserverList extends NyARPointerStack
{
	public function ObserverList(i_length:int)
	{
		super.initInstance(i_length);
	}
	public function notifyOnUpdateCameraParametor(i_param:NyARParam,i_near:Number,i_far:Number):void
	{
		for(var i:int=0;i<this._length;i++){
			this._items[i].onUpdateCameraParametor(i_param,i_near,i_far);
		}
	}
}
