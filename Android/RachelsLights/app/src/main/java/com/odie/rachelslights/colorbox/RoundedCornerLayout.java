package com.odie.rachelslights.colorbox;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapShader;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.graphics.Shader;
import android.util.AttributeSet;
import android.widget.FrameLayout;
import com.odie.rachelslights.R;

class RoundedCornerLayout extends FrameLayout {

    private Bitmap mOffscreenBitmap;
    private Canvas mOffscreenCanvas;
    private Paint mPaint;
    private RectF mRectF;

    public RoundedCornerLayout(Context context) {
        super(context);
        init();
    }

    public RoundedCornerLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public RoundedCornerLayout(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private void init() {
        setWillNotDraw(false);
    }

    @Override
    public void draw(Canvas canvas) {
        if (mOffscreenBitmap == null) {
            mOffscreenBitmap = Bitmap.createBitmap(canvas.getWidth(), canvas.getHeight(), Bitmap.Config.ARGB_8888);
            mOffscreenCanvas = new Canvas(mOffscreenBitmap);
            BitmapShader mBitmapShader = new BitmapShader(mOffscreenBitmap, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP);
            mPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
            mPaint.setShader(mBitmapShader);
            mRectF = new RectF(0f, 0f, canvas.getWidth(), canvas.getHeight());
        }
        super.draw(mOffscreenCanvas);

        canvas.drawRoundRect(mRectF, 16, 16, mPaint);
    }
}