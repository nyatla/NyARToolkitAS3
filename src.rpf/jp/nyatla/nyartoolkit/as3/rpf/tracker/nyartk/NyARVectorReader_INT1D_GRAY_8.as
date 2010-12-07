/* 
 * PROJECT: NyARToolkit(Extension)
 * --------------------------------------------------------------------------------
 * The NyARToolkit is Java edition ARToolKit class library.
 * Copyright (C)2008-2009 Ryo Iizuka
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
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk
{

	import jp.nyatla.nyartoolkit.as3.NyARException;
	import jp.nyatla.nyartoolkit.as3.core.param.NyARCameraDistortionFactor;
	import jp.nyatla.nyartoolkit.as3.core.raster.NyARGrayscaleRaster;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.NyARContourPickup;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.utils.NyARMath;
	import jp.nyatla.nyartoolkit.as3.rpf.utils.*;

	/**
	 * グレイスケールラスタに対する、特殊な画素アクセス手段を提供します。
	 *
	 */
	public class NyARVectorReader_INT1D_GRAY_8
	{
		private var _tmp_coord_pos:Vector.<VecLinearCoordinatePoint>;
		private var _rob_resolution:int;
		private var _ref_base_raster:NyARGrayscaleRaster;
		private var _ref_rob_raster:NyARGrayscaleRaster;
		private var _factor:NyARCameraDistortionFactor;
		/**
		 * 
		 * @param i_ref_raster
		 * 基本画像
		 * @param i_ref_raster_distortion
		 * 歪み解除オブジェクト(nullの場合歪み解除を省略)
		 * @param i_ref_rob_raster
		 * エッジ探索用のROB画像
		 * @param 
		 */
		public function NyARVectorReader_INT1D_GRAY_8(i_ref_raster:NyARGrayscaleRaster,i_ref_raster_distortion:NyARCameraDistortionFactor,i_ref_rob_raster:NyARGrayscaleRaster)
		{
			//assert (i_ref_raster.getBufferType() == NyARBufferType.INT1D_GRAY_8);
			this._rob_resolution=i_ref_raster.getWidth()/i_ref_rob_raster.getWidth();
			this._ref_rob_raster=i_ref_rob_raster;
			this._ref_base_raster=i_ref_raster;
			this._coord_buf = new NyARIntCoordinates((i_ref_raster.getWidth() + i_ref_raster.getHeight()) * 4);
			this._factor=i_ref_raster_distortion;
			this._tmp_coord_pos=VecLinearCoordinatePoint.createArray(this._coord_buf.items.length);
		}
		/**
		 * RECT範囲内の画素ベクトルの合計値と、ベクトルのエッジ中心を取得します。 320*240の場合、
		 * RECTの範囲は(x>=0 && x<319 x+w>=0 && x+w<319),(y>=0 && y<239 x+w>=0 && x+w<319)となります。
		 * @param ix
		 * ピクセル取得を行う位置を設定します。
		 * @param iy
		 * ピクセル取得を行う位置を設定します。
		 * @param iw
		 * ピクセル取得を行う範囲を設定します。
		 * @param ih
		 * ピクセル取得を行う範囲を設定します。
		 * @param o_posvec
		 * エッジ中心とベクトルを返します。
		 * @return
		 * ベクトルの強度を返します。強度値は、差分値の二乗の合計です。
		 */
		public function getAreaVector33(ix:int,iy:int,iw:int,ih:int,o_posvec:NyARVecLinear2d):int
		{
			//assert (ih >= 3 && iw >= 3);
			//assert ((ix >= 0) && (iy >= 0) && (ix + iw) <= this._ref_base_raster.getWidth() && (iy + ih) <= this._ref_base_raster.getHeight());
			var buf:Vector.<int> =(Vector.<int>)(this._ref_base_raster.getBuffer());
			var stride:int =this._ref_base_raster.getWidth();
			// x=(Σ|Vx|*Xn)/n,y=(Σ|Vy|*Yn)/n
			// x=(ΣVx)^2/(ΣVx+ΣVy)^2,y=(ΣVy)^2/(ΣVx+ΣVy)^2
			var sum_x:int, sum_y:int, sum_wx:int, sum_wy:int, sum_vx:int, sum_vy:int;
			sum_x = sum_y = sum_wx = sum_wy = sum_vx = sum_vy = 0;
			var lw:int=iw - 3;
			var vx:int, vy:int;
			for (var i:int = ih - 3; i >= 0; i--) {
				var idx_0:int = stride * (i + 1 + iy) + (iw - 3 + 1 + ix);
				for (var i2:int = lw; i2 >= 0; i2--){
					// 1ビット分のベクトルを計算
					var idx_p1:int = idx_0 + stride;
					var idx_m1:int = idx_0 - stride;
					var b:int = buf[idx_m1 - 1];
					var d:int = buf[idx_m1 + 1];
					var h:int = buf[idx_p1 - 1];
					var f:int = buf[idx_p1 + 1];
					vx = ((buf[idx_0 + 1] - buf[idx_0 - 1]) >> 1)+ ((d - b + f - h) >> 2);
					vy = ((buf[idx_p1] - buf[idx_m1]) >> 1)+ ((f - d + h - b) >> 2);
					idx_0--;

					// 加重はvectorの絶対値
					var wx:int = vx * vx;
					var wy:int = vy * vy;
					sum_wx += wx; //加重値
					sum_wy += wy; //加重値
					sum_vx += wx * vx; //加重*ベクトルの積
					sum_vy += wy * vy; //加重*ベクトルの積
					sum_x += wx * (i2 + 1);//位置
					sum_y += wy * (i + 1); //
				}
			}
			//x,dx,y,dyの計算
			var xx:Number,yy:Number;
			if (sum_wx == 0) {
				xx = ix + (iw >> 1);
				o_posvec.dx = 0;
			} else {
				xx = ix+Number(sum_x) / Number(sum_wx);
				o_posvec.dx = Number(sum_vx) / Number(sum_wx);
			}
			if (sum_wy == 0) {
				yy = iy + (ih >> 1);
				o_posvec.dy = 0;
			} else {
				yy = iy+Number(sum_y) / Number(sum_wy);
				o_posvec.dy = Number(sum_vy) / Number(sum_wy);
			}
			//必要なら歪みを解除
			if(this._factor!=null){
				this._factor.observ2Ideal_2(xx, yy, o_posvec);
			}else{
				o_posvec.x=xx;
				o_posvec.y=yy;
			}
			//加重平均の分母を返却
			return sum_wx+sum_wy;
		}
		public function getAreaVector22(ix:int,iy:int,iw:int,ih:int,o_posvec:NyARVecLinear2d):int
		{
			//assert (ih >= 3 && iw >= 3);
			//assert ((ix >= 0) && (iy >= 0) && (ix + iw) <= this._ref_base_raster.getWidth() && (iy + ih) <= this._ref_base_raster.getHeight());
			var buf:Vector.<int> =(Vector.<int>)(this._ref_base_raster.getBuffer());
			var stride:int =this._ref_base_raster.getWidth();
			var sum_x:int, sum_y:int, sum_wx:int, sum_wy:int, sum_vx:int, sum_vy:int;
			sum_x = sum_y = sum_wx = sum_wy = sum_vx = sum_vy = 0;
			var vx:int, vy:int;
			var ll:int=iw-1;
			for (var i:int = 0; i<ih-1; i++) {
				var idx_0:int = stride * (i+iy) + ix+1;
				var a:int=buf[idx_0-1];
				var b:int=buf[idx_0];
				var c:int=buf[idx_0+stride-1];
				var d:int=buf[idx_0+stride];
				for (var i2:int = 0; i2<ll; i2++){
					// 1ビット分のベクトルを計算
					vx=(b-a+d-c)>>2;
					vy=(c-a+d-b)>>2;
					idx_0++;
					a=b;
					c=d;
					b=buf[idx_0];
					d=buf[idx_0+stride];

					// 加重はvectorの絶対値
					var wx:int = vx * vx;
					sum_wx += wx; //加重値
					sum_vx += wx * vx; //加重*ベクトルの積
					sum_x += wx * i2;//位置

					var wy:int = vy * vy;
					sum_wy += wy; //加重値
					sum_vy += wy * vy; //加重*ベクトルの積
					sum_y += wy * i; //
				}
			}
			//x,dx,y,dyの計算
			var xx:Number,yy:Number;
			if (sum_wx == 0) {
				xx = ix + (iw >> 1);
				o_posvec.dx = 0;
			} else {
				xx = ix+Number(sum_x) / Number(sum_wx);
				o_posvec.dx = Number(sum_vx) / Number(sum_wx);
			}
			if (sum_wy == 0) {
				yy = iy + (ih >> 1);
				o_posvec.dy = 0;
			} else {
				yy = iy+Number(sum_y) / Number(sum_wy);
				o_posvec.dy = Number(sum_vy) / Number(sum_wy);
			}
			//必要なら歪みを解除
			if(this._factor!=null){
				this._factor.observ2Ideal_2(xx, yy, o_posvec);
			}else{
				o_posvec.x=xx;
				o_posvec.y=yy;
			}
			//加重平均の分母を返却
			return sum_wx+sum_wy;
		}

		/**
		 * ワーク変数
		 */
		protected var _coord_buf:NyARIntCoordinates;
		private var  _cpickup:NyARContourPickup = new NyARContourPickup();
		protected const _MARGE_ANG_TH:Number = NyARMath.COS_DEG_10;

		public function traceConture_1(i_th:int,
				i_entry:NyARIntPoint2d,o_coord:VecLinearCoordinates):Boolean
		{
			var coord:NyARIntCoordinates = this._coord_buf;
			// Robertsラスタから輪郭抽出
			if (!this._cpickup.getContour_3(this._ref_rob_raster, i_th, i_entry.x, i_entry.y,
					coord)) {
				// 輪郭線MAXならなにもできないね。
				return false;

			}
			// 輪郭線のベクトル化
			return traceConture_2(coord, this._rob_resolution,
					this._rob_resolution * 2, o_coord);
		}



		/**
		 * 点1と点2の間に線分を定義して、その線分上のベクトルを得ます。点は、画像の内側でなければなりません。 320*240の場合、(x>=0 &&
		 * x<320 x+w>0 && x+w<320),(y>0 && y<240 y+h>=0 && y+h<=319)となります。
		 * 
		 * @param i_pos1
		 *            点1の座標です。
		 * @param i_pos2
		 *            点2の座標です。
		 * @param i_area
		 *            ベクトルを検出するカーネルサイズです。1の場合(n*2-1)^2のカーネルになります。 点2の座標です。
		 * @param o_coord
		 *            結果を受け取るオブジェクトです。
		 * @return
		 * @throws NyARException
		 */
		public function traceLine_1(i_pos1:NyARIntPoint2d,i_pos2:NyARIntPoint2d,i_edge:int ,o_coord:VecLinearCoordinates):Boolean
		{
			var coord:NyARIntCoordinates = this._coord_buf;
			var base_s:NyARIntSize=this._ref_base_raster.getSize();
			// (i_area*2)の矩形が範囲内に収まるように線を引く
			// 移動量

			// 点間距離を計算
			var dist:int  = (int)(Math.sqrt(i_pos1.sqDist(i_pos2)));
			// 最低AREA*2以上の大きさが無いなら、ラインのトレースは不可能。
			if (dist < 4) {
				return false;
			}
			// dist最大数の決定
			if (dist > 22) {
				dist = 22;
			}
			// サンプリングサイズを決定(移動速度とサイズから)
			var s:int = i_edge * 2 + 1;
			var dx:int = (i_pos2.x - i_pos1.x);
			var dy:int = (i_pos2.y - i_pos1.y);
			var r:int = base_s.w - s;
			var b:int = base_s.h - s;

			// 最大14点を定義して、そのうち両端を除いた点を使用する。
			for (var i:int = 1; i < dist - 1; i++) {
				var x:int = i * dx / dist + i_pos1.x - i_edge;
				var y:int = i * dy / dist + i_pos1.y - i_edge;
				// limit
				coord.items[i - 1].x = x < 0 ? 0 : (x >= r ? r : x);
				coord.items[i - 1].y = y < 0 ? 0 : (y >= b ? b : y);
			}

			coord.length = dist - 4;
			// 点数は20点程度を得る。
			return traceConture_2(coord, 1, s, o_coord);
		}

		public function traceLine_2(i_pos1:NyARDoublePoint2d,i_pos2:NyARDoublePoint2d,i_edge:int,o_coord:VecLinearCoordinates):Boolean
		{
			var coord:NyARIntCoordinates = this._coord_buf;
			var base_s:NyARIntSize=this._ref_base_raster.getSize();
			// (i_area*2)の矩形が範囲内に収まるように線を引く
			// 移動量

			// 点間距離を計算
			var dist:int = (int)(Math.sqrt(i_pos1.sqDist_1(i_pos2)));
			// 最低AREA*2以上の大きさが無いなら、ラインのトレースは不可能。
			if (dist < 4) {
				return false;
			}
			// dist最大数の決定
			if (dist > 14) {
				dist = 14;
			}
			// サンプリングサイズを決定(移動速度とサイズから)
			var s:int = i_edge * 2 + 1;
			var dx:int = (int) (i_pos2.x - i_pos1.x);
			var dy:int = (int) (i_pos2.y - i_pos1.y);
			var r:int = base_s.w - s;
			var b:int = base_s.h - s;

			// 最大24点を定義して、そのうち両端の2個を除いた点を使用する。
			for (var i:int = 3; i < dist - 1; i++) {
				var x:int = (int) (i * dx / dist + i_pos1.x - i_edge);
				var y:int = (int) (i * dy / dist + i_pos1.y - i_edge);
				// limit
				coord.items[i - 3].x = x < 0 ? 0 : (x >= r ? r : x);
				coord.items[i - 3].y = y < 0 ? 0 : (y >= b ? b : y);
			}

			coord.length = dist - 4;
			// 点数は10点程度を得る。
			return traceConture_2(coord, 1, s, o_coord);
		}
		//ベクトルの類似度判定式
		public static function checkVecCos(i_current_vec:VecLinearCoordinatePoint,i_prev_vec:VecLinearCoordinatePoint,i_ave_dx:Number,i_ave_dy:Number):Boolean
		{
			var x1:Number=i_current_vec.dx;
			var y1:Number=i_current_vec.dy;
			var n:Number=(x1*x1+y1*y1);
			//平均ベクトルとこのベクトルがCOS_DEG_20未満であることを確認(pos_ptr.getAbsVecCos(i_ave_dx,i_ave_dy)<NyARMath.COS_DEG_20 と同じ)
			var d:Number;
			d=(x1*i_ave_dx+y1*i_ave_dy)/NyARMath.COS_DEG_20;
			if(d*d<(n*(i_ave_dx*i_ave_dx+i_ave_dy*i_ave_dy))){
				//隣接ベクトルとこのベクトルが5度未満であることを確認(pos_ptr.getAbsVecCos(i_prev_vec)<NyARMath.COS_DEG_5と同じ)
				d=(x1*i_prev_vec.dx+y1*i_prev_vec.dy)/NyARMath.COS_DEG_5;
				if(d*d<n*(i_prev_vec.dx*i_prev_vec.dx+i_prev_vec.dy*i_prev_vec.dy)){
					return true;
				}
			}
			return false;
		}
		/**
		 * 輪郭線を取得します。
		 * 取得アルゴリズムは、以下の通りです。
		 * 1.輪郭座標(n)の画素周辺の画素ベクトルを取得。
		 * 2.輪郭座標(n+1)周辺の画素ベクトルと比較。
		 * 3.差分が一定以下なら、座標と強度を保存
		 * 4.3点以上の集合になったら、最小二乗法で直線を計算。
		 * 5.直線の加重値を個々の画素ベクトルの和として返却。
		 */
		public function traceConture_2(i_coord:NyARIntCoordinates,i_pos_mag:int,i_cell_size:int ,o_coord: VecLinearCoordinates):Boolean
		{
			var pos:Vector.<VecLinearCoordinatePoint>=this._tmp_coord_pos;
			// ベクトル化
			var MAX_COORD:int = o_coord.items.length;
			var i_coordlen:int = i_coord.length;
			var coord:Vector.<NyARIntPoint2d> = i_coord.items;
			var pos_ptr:VecLinearCoordinatePoint;

			//0個目のライン探索
			var number_of_data:int = 0;
			var sq:Number;
			var sq_sum:Number=0;
			//0番目のピクセル
			pos[0].scalar=sq=this.getAreaVector33(coord[0].x * i_pos_mag, coord[0].y * i_pos_mag,i_cell_size, i_cell_size,pos[0]);
			sq_sum+=sq;
			//[2]に0を保管

			//1点目だけは前方と後方、両方に探索をかける。
			//前方探索の終点
			var coord_last_edge:int=i_coordlen;
			//後方探索
			var sum:int=1;
			var ave_dx:Number=pos[0].dx;
			var ave_dy:Number = pos[0].dy;
			var i:int;
			for (i = i_coordlen-1; i >0; i--)
			{
				// ベクトル取得
				pos_ptr=pos[sum];
				pos_ptr.scalar=sq=this.getAreaVector33(coord[i].x * i_pos_mag,coord[i].y * i_pos_mag, i_cell_size, i_cell_size,pos_ptr);
				sq_sum+=sq;
				// 類似度判定
				if(checkVecCos(pos[sum],pos[sum-1],ave_dx,ave_dy))
				{
					//相関なし->前方探索へ。
					ave_dx=pos_ptr.dx;
					ave_dy=pos_ptr.dy;
					coord_last_edge=i;
					break;
				} else {
					//相関あり- 点の蓄積
					ave_dx+=pos_ptr.dx;
					ave_dy+=pos_ptr.dy;
					sum++;
				}
			}
			//前方探索
			for (i = 1; i<coord_last_edge; i++)
			{
				// ベクトル取得
				pos_ptr=pos[sum];
				pos_ptr.scalar=sq=this.getAreaVector33(coord[i].x * i_pos_mag,coord[i].y * i_pos_mag, i_cell_size, i_cell_size,pos_ptr);
				sq_sum+=sq;			
				if(sq==0){
					continue;
				}
				//if (pos_ptr.getAbsVecCos(pos[sum-1]) < NyARMath.COS_DEG_5 && pos_ptr.getAbsVecCos(ave_dx,ave_dy)<NyARMath.COS_DEG_20) {
				if (checkVecCos(pos[sum],pos[sum-1],ave_dx,ave_dy)) {
					//相関なし->新しい要素を作る。
					if(this.leastSquaresWithNormalize(pos,sum,o_coord.items[number_of_data],sq_sum/(sum*20))){
						number_of_data++;
					}
					ave_dx=pos_ptr.dx;
					ave_dy=pos_ptr.dy;
					//獲得した値を0へ移動
					pos[0].setValue(pos[sum]);
					sq_sum=0;
					sum=1;
				} else {
					//相関あり- 点の蓄積
					ave_dx+=pos_ptr.dx;
					ave_dy+=pos_ptr.dy;				
					sum++;
				}
				// 輪郭中心を出すための計算
				if (number_of_data == MAX_COORD) {
					// 輪郭ベクトルバッファの最大を超えたら失敗
					return false;
				}
			}
			if(this.leastSquaresWithNormalize(pos,sum,o_coord.items[number_of_data],sq_sum/(sum*10))){
				number_of_data++;
			}
			// ベクトル化2:最後尾と先頭の要素が似ていれば連結する。
			// sq_distの合計を計算
			o_coord.length = number_of_data;

			return true;
		}
		/**
		 * ノイズらしいベクトルを無視しながら最小二乗法でベクトルを統合する関数
		 * @param i_points
		 * @param i_number_of_data
		 * @param o_dest
		 * @param i_scale_th
		 * @return
		 */
		private function leastSquaresWithNormalize(i_points:Vector.<VecLinearCoordinatePoint>,i_number_of_data:int,o_dest:VecLinearCoordinatePoint,i_scale_th:Number):Boolean
		{
			var i:int;
			var num:int=0;
			var sum_xy:Number = 0, sum_x:Number = 0, sum_y:Number = 0, sum_x2:Number = 0;
			for (i=i_number_of_data-1; i>=0; i--){
				var ptr:VecLinearCoordinatePoint=i_points[i];
				//規定より小さいスケールは除外なう
				if(ptr.scalar<i_scale_th)
				{
					continue;
				}
				var xw:Number=ptr.x;
				sum_xy += xw * ptr.y;
				sum_x += xw;
				sum_y += ptr.y;
				sum_x2 += xw*xw;
				num++;
			}
			if(num<3){
				return false;
			}
			var la:Number=-(num * sum_x2 - sum_x*sum_x);
			var lb:Number=-(num * sum_xy - sum_x * sum_y);
			var cc:Number=(sum_x2 * sum_y - sum_xy * sum_x);
			var lc:Number=-(la*sum_x+lb*sum_y)/num;
			//交点を計算
			var w1:Number = -lb * lb - la * la;
			if (w1 == 0.0) {
				return false;
			}		
			o_dest.x=((la * lc - lb * cc) / w1);
			o_dest.y= ((la * cc +lb * lc) / w1);
			o_dest.dy=-lb;
			o_dest.dx=-la;
			o_dest.scalar=num;
			return true;
		}	

		private var __pt:Vector.<NyARIntPoint2d> = NyARIntPoint2d.createArray(2);
		private var __temp_l:NyARLinear = new NyARLinear();

		/**
		 * クリッピング付きのライントレーサです。
		 * 
		 * @param i_pos1
		 * @param i_pos2
		 * @param i_edge
		 * @param o_coord
		 * @return
		 * @throws NyARException
		 */
		public function traceLineWithClip(i_pos1:NyARDoublePoint2d,i_pos2:NyARDoublePoint2d, i_edge:int , o_coord:VecLinearCoordinates ):Boolean
		{
			var s:NyARIntSize=this._ref_base_raster.getSize();
			var is_p1_inside_area:Boolean, is_p2_inside_area:Boolean;

			var pt:Vector.<NyARIntPoint2d> = this.__pt;
			// 線分が範囲内にあるかを確認
			is_p1_inside_area = s.isInnerPoint_2(i_pos1);
			is_p2_inside_area = s.isInnerPoint_2(i_pos2);
			// 個数で分岐
			if (is_p1_inside_area && is_p2_inside_area) {
				// 2ならクリッピング必要なし。
				if (!this.traceLine_2(i_pos1, i_pos2, i_edge, o_coord)) {
					return false;
				}
				return true;

			}
			// 1,0個の場合は、線分を再定義
			if (!this.__temp_l.makeLinearWithNormalize_2(i_pos1, i_pos2)) {
				return false;
			}
			if (!this.__temp_l.makeSegmentLine_1(s.w,s.h,pt)) {
				return false;
			}
			if (is_p1_inside_area != is_p2_inside_area) {
				// 1ならクリッピング後に、外に出ていた点に近い輪郭交点を得る。

				if (is_p1_inside_area) {
					// p2が範囲外
					pt[(i_pos2.sqDist_2(pt[0]) < i_pos2.sqDist_2(pt[1])) ? 1 : 0].setValue_2(i_pos1);
				} else {
					// p1が範囲外
					pt[(i_pos1.sqDist_2(pt[0]) < i_pos2.sqDist_2(pt[1])) ? 1 : 0].setValue_2(i_pos2);
				}
			} else {
				// 0ならクリッピングして得られた２点を使う。
				if (!this.__temp_l.makeLinearWithNormalize_2(i_pos1, i_pos2)) {
					return false;
				}
				if (!this.__temp_l.makeSegmentLine_1(s.w,s.h, pt)) {
					return false;
				}
			}
			if (!this.traceLine_1(pt[0], pt[1], i_edge, o_coord)) {
				return false;
			}

			return true;
		}
	}
}