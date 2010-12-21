/* 
 * FLARTest
 * --------------------------------------------------------------------------------
 * Copyright (C)2010 nyatla
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */
package{

	import flash.geom.Matrix;
	import jp.nyatla.as3utils.*;
	import flash.net.*;
	import flash.text.*;
    import flash.display.*; 
    import flash.events.*;
    import flash.utils.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.NyARRgbRaster;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.transmat.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2gs.*;
	import org.libspark.flartoolkit.detector.*;
	import org.libspark.flartoolkit.rpf.reality.nyartk.*;
	import org.libspark.flartoolkit.rpf.realitysource.nyartk.*;
	import org.libspark.flartoolkit.rpf.*;
	import jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.status.*;
	import jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import flash.media.*;
	/**
	 * Trackerの性能試験プログラム。
	 */
	public class TrackerView extends Sprite 
	{
		
		public static var inst:TrackerView;
		public var bitmap:Bitmap = new Bitmap(new BitmapData(320,240));
        private var textbox:TextField = new TextField();
		public function msg(i_str:String):void
		{
			this.textbox.text = this.textbox.text + "\n" + i_str;
		}
		public static function megs(i_str:String):void
		{
			inst.msg(i_str);
		}
		
		public function TrackerView():void 
		{
			TrackerView.inst = this;
			main();
            return;//dispatch event*/
		}

		protected var _webcam:Camera;
		protected var _video:Video;
		protected var _capture:Bitmap;
		private static const WIDTH:int = 320;
		private static const HEIGHT:int = 240;
		private var dobj:Array = new Array();
		
		protected var _tracker:NyARTracker;
		protected var _tracksource:FLARTrackerSource_Reference;
		protected var _nytracksource:NyARTrackerSource_Reference
		protected var _filter:FLARRasterFilter_Rgb2Gs_RgbAve192;
		protected var _nyfilter:NyARRasterFilter_Rgb2Gs_RgbAve192;
		protected var _raster:FLARRgbRaster_BitmapData;		
		
		private function main():void
		{
			this._tracker = new NyARTracker(100, 1, 10);
			this._tracksource = new FLARTrackerSource_Reference(100, null, WIDTH, HEIGHT, 2, true);
			this._webcam = Camera.getCamera();
			if (!this._webcam) {
				throw new Error('No webcam!!!!');
			}
			this._webcam.setMode(WIDTH,HEIGHT, 15);
			this._video = new Video( WIDTH,HEIGHT);
			this._video.attachCamera(_webcam);
			this._filter = new FLARRasterFilter_Rgb2Gs_RgbAve192();
			this._raster = new FLARRgbRaster_BitmapData(WIDTH,HEIGHT,true);
			this.addEventListener(Event.ENTER_FRAME, _onEnterFrame);

			return;
		}
		private function drawtext(x:int,y:int,text:String,c:uint):void
		{
			var  tf:TextField = new  TextField;
			tf.defaultTextFormat = new TextFormat("System", 12, c );
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = text;
			this.addChild(tf);
			tf.x = x;
			tf.y = y;
			this.dobj.push(tf);
		}
		
		
		private function _onEnterFrame(e:Event = null):void
		{this.graphics.clear();

			this._raster.setVideo(this._video);
			this._filter.doFilter(this._raster, this._tracksource.refBaseRaster());
			this._tracksource.syncResource();
			this._tracker.progress(this._tracksource);
			while (dobj.length > 0) {
				this.removeChild(dobj.pop());
			}
            this.addChild(bitmap);
			this.dobj.push(bitmap);
			for(var i:int=this._tracker._targets.getLength()-1;i>=0;i--){
				switch(NyARTarget(this._tracker._targets.getItem(i))._st_type)
				{
				case NyARTargetStatus.ST_CONTURE:
					drawCTarget(this.bitmap.bitmapData,NyARTarget(this._tracker._targets.getItem(i)));
					break;
				case NyARTargetStatus.ST_IGNORE:
					drawITarget(this.bitmap.bitmapData,NyARTarget(this._tracker._targets.getItem(i)));
					break;
				case NyARTargetStatus.ST_NEW:
					drawNTarget(this.bitmap.bitmapData,NyARTarget(this._tracker._targets.getItem(i)));
					break;
				case NyARTargetStatus.ST_RECT:
					drawRTarget(this.bitmap.bitmapData,NyARTarget(this._tracker._targets.getItem(i)));
					break;
				}
			}			
			this.bitmap.bitmapData.draw(BitmapData(this._raster.getBuffer()));
//			this.msg("N:" + this._tracker.getNumberOfNew() + " C:" + this._tracker.getNumberOfContur() + " R:" + this._tracker.getNumberOfRect());
		}
		private function drawCTarget(i_out:BitmapData,i_target:NyARTarget):void
		{
			drawtext(i_target._sample_area.x, i_target._sample_area.y, ("IG" + "-" + i_target._delay_tick), 0x0000ff);
			this.graphics.drawRect(i_target._sample_area.x, i_target._sample_area.y, i_target._sample_area.w, i_target._sample_area.h);
		}
		private function drawRTarget(i_out:BitmapData,i_target:NyARTarget):void
		{
			var s:NyARRectTargetStatus = NyARRectTargetStatus(i_target._ref_status);
			drawtext(i_target._sample_area.x,i_target._sample_area.y, ("RT:" + i_target._serial + "(" + s.detect_type + ")" + "-" + i_target._delay_tick), 0x00ffff);
            var shape:Shape = new Shape(); 
			shape.graphics.beginFill(0xff000000,0);
            shape.graphics.lineStyle(1, 0x00ffff);
			//shape.graphics.drawRect(i_target._sample_area.x, i_target._sample_area.y, i_target._sample_area.w, i_target._sample_area.h);
			for (var i2:int = 0; i2 < 4; i2++) {
				shape.graphics.moveTo(s.vertex[i2].x, s.vertex[i2].y);
				shape.graphics.lineTo(s.vertex[(i2+1)%4].x, s.vertex[(i2+1)%4].y);
			}	
			shape.graphics.drawRect(s.vertex[0].x - 1, s.vertex[0].y - 1, 2, 2);
	        shape.graphics.endFill();
			this.addChild(shape);
			this.dobj.push(shape);
			

		}
		private function drawNTarget(i_out:BitmapData,i_target:NyARTarget):void
		{
			drawtext(i_target._sample_area.x, i_target._sample_area.y, ("NW" + "-" +i_target._delay_tick), 0x00ff00);
			var shape:Shape = new Shape(); 
            shape.graphics.beginFill(0xff000000,0);
            shape.graphics.lineStyle(1, 0x0000ff00);
			shape.graphics.drawRect(i_target._sample_area.x, i_target._sample_area.y, i_target._sample_area.w, i_target._sample_area.h);
	        shape.graphics.endFill();
			this.addChild(shape);
			this.dobj.push(shape);
			
		}
		private function drawITarget(i_out:BitmapData,i_target:NyARTarget):void
		{			
			drawtext(i_target._sample_area.x,i_target._sample_area.y, ("IG" + "-" +i_target._delay_tick), 0xff0000);
			var shape:Shape = new Shape(); 
            shape.graphics.beginFill(0xff000000,0);
            shape.graphics.lineStyle(1, 0xff0000);
			shape.graphics.drawRect(i_target._sample_area.x, i_target._sample_area.y, i_target._sample_area.w, i_target._sample_area.h);
	        shape.graphics.endFill();
			this.addChild(shape);
			this.dobj.push(shape);
		}
	}

}
