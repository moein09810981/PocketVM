
package com.pocketvm;

import android.app.Activity;
import android.os.Bundle;
import android.graphics.Color;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.TextView;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setGravity(Gravity.CENTER);
        layout.setPadding(24, 24, 24, 24);
        layout.setBackgroundColor(Color.rgb(245, 247, 250));

        TextView title = new TextView(this);
        title.setText("PocketVM");
        title.setTextSize(30);
        title.setTextColor(Color.rgb(35, 45, 65));
        title.setGravity(Gravity.CENTER);

        TextView message = new TextView(this);
        message.setText("محیط اجرای سیستم‌عامل‌ها\n\nهنوز ماشین مجازی اضافه نشده است.");
        message.setTextSize(17);
        message.setTextColor(Color.DKGRAY);
        message.setGravity(Gravity.CENTER);
        message.setPadding(0, 24, 0, 24);

        layout.addView(title);
        layout.addView(message);

        setContentView(layout);
    }
}
