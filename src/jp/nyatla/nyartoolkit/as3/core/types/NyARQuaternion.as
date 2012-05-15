package jp.nyatla.nyartoolkit.as3.core.types 
{
	import jp.nyatla.nyartoolkit.as3.core.types.matrix.*;
	/**
	 * ...
	 * @author nyatla
	 */
	public class NyARQuaternion 
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var w:Number;
		
		public function setFromMatrix(i_mat:NyARDoubleMatrix44):void
		{
			// 最大成分を検索
			var elem0:Number = i_mat.m00 - i_mat.m11 - i_mat.m22 + 1.0;
			var elem1:Number = -i_mat.m00 + i_mat.m11 - i_mat.m22 + 1.0;
			var elem2:Number = -i_mat.m00 - i_mat.m11 + i_mat.m22 + 1.0;
			var elem3:Number = i_mat.m00 + i_mat.m11 + i_mat.m22 + 1.0;
			
			var v:Number = 0;
			var mult:Number = 0;
			
			if(elem0>elem1 && elem0>elem2 && elem0>elem3){
				v = Math.sqrt(elem0) * 0.5;
				mult = 0.25 / v;
				this.x = v;
				this.y = ((i_mat.m10 + i_mat.m01) * mult);
				this.z = ((i_mat.m02 + i_mat.m20) * mult);
				this.w = ((i_mat.m21 - i_mat.m12) * mult);
			}else if(elem1>elem2 && elem1>elem3){
				v = Math.sqrt(elem1) * 0.5;
				mult = 0.25 / v;
				this.x = ((i_mat.m10 + i_mat.m01) * mult);
				this.y = (v);
				this.z = ((i_mat.m21 + i_mat.m12) * mult);
				this.w = ((i_mat.m02 - i_mat.m20) * mult);
			}else if(elem2>elem3){
				v = Math.sqrt(elem2) * 0.5;
				mult = 0.25 / v;
				this.x =((i_mat.m02 + i_mat.m20) * mult);
				this.y =((i_mat.m21 + i_mat.m12) * mult);
				this.z =(v);
				this.w =((i_mat.m10 - i_mat.m01) * mult);
			}else{
				v = Math.sqrt(elem3) * 0.5;
				mult = 0.25 / v;
				this.x =((i_mat.m21 - i_mat.m12) * mult);
				this.y =((i_mat.m02 - i_mat.m20) * mult);
				this.z =((i_mat.m10 - i_mat.m01) * mult);
				this.w =v;
			}
			return;
		}
	}

}