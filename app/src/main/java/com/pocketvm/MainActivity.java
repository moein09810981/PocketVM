
package com.pocketvm;

import android.app.Activity;
import android.os.Bundle;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends Activity {

    final int BG = Color.rgb(10, 12, 15);
    final int CARD = Color.rgb(20, 23, 28);
    final int ORANGE = Color.rgb(255, 100, 15);
    final int WHITE = Color.rgb(245, 246, 248);
    final int MUTED = Color.rgb(145, 151, 162);
    final int GREEN = Color.rgb(43, 211, 133);

    LinearLayout content;
    TextView homeTab, machinesTab, downloadsTab, settingsTab;

    @Override
    protected void onCreate(Bundle state) {
        super.onCreate(state);

        getWindow().setStatusBarColor(BG);
        getWindow().setNavigationBarColor(BG);

        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(BG);
        root.setLayoutDirection(View.LAYOUT_DIRECTION_RTL);

        ScrollView scroll = new ScrollView(this);
        scroll.setFillViewport(true);

        content = new LinearLayout(this);
        content.setOrientation(LinearLayout.VERTICAL);
        content.setPadding(dp(20), dp(20), dp(20), dp(24));
        content.setLayoutDirection(View.LAYOUT_DIRECTION_RTL);

        scroll.addView(content);
        root.addView(scroll, new LinearLayout.LayoutParams(-1, 0, 1));

        root.addView(createNavigation());
        setContentView(root);

        showHome();
    }

    void showHome() {
        content.removeAllViews();

        LinearLayout header = new LinearLayout(this);
        header.setGravity(Gravity.CENTER_VERTICAL);

        LinearLayout logo = new LinearLayout(this);
        logo.setGravity(Gravity.CENTER);
        logo.setBackground(round(ORANGE, 15));
        TextView mark = text("P", 25, Color.BLACK, true);
        logo.addView(mark);
        header.addView(logo, params(48, 48));

        LinearLayout brand = new LinearLayout(this);
        brand.setOrientation(LinearLayout.VERTICAL);
        brand.setPadding(dp(12), 0, 0, 0);
        brand.addView(text("PocketVM", 22, WHITE, true));
        brand.addView(text("YOUR VM, YOUR CONTROL", 9, MUTED, true));
        header.addView(brand, new LinearLayout.LayoutParams(0, -2, 1));

        TextView settings = text("⚙", 25, WHITE, false);
        settings.setGravity(Gravity.CENTER);
        settings.setOnClickListener(v -> showSettings());
        header.addView(settings, params(44, 44));

        content.addView(header);

        space(30);
        content.addView(text("ماشین‌های مجازی تو", 25, WHITE, true));
        space(6);
        content.addView(text("سیستم‌عاملت رو انتخاب کن و اجرا کن.", 14, MUTED, false));

        space(22);
        content.addView(createFeaturedCard());

        space(22);
        content.addView(text("نمای کلی", 18, WHITE, true));
        space(12);

        LinearLayout stats = new LinearLayout(this);
        stats.addView(stat("ماشین‌ها", "۰", "ماشین ساخته‌شده"),
                new LinearLayout.LayoutParams(0, dp(105), 1));
        stats.addView(gap(10), params(10, 1));
        stats.addView(stat("موتور", "QEMU", "آماده‌سازی نشده"),
                new LinearLayout.LayoutParams(0, dp(105), 1));
        content.addView(stats);

        space(26);
        LinearLayout titleRow = new LinearLayout(this);
        titleRow.setGravity(Gravity.CENTER_VERTICAL);
        titleRow.addView(text("ماشین‌های من", 18, WHITE, true),
                new LinearLayout.LayoutParams(0, -2, 1));

        TextView add = text("+ افزودن", 13, ORANGE, true);
        add.setOnClickListener(v -> showCreate());
        titleRow.addView(add);
        content.addView(titleRow);

        space(12);
        content.addView(createMachineRow(
                "Linux", "Alpine Linux ARM64", "آمادهٔ راه‌اندازی", "◈"));
        space(10);

        LinearLayout empty = new LinearLayout(this);
        empty.setGravity(Gravity.CENTER);
        empty.setPadding(dp(12), dp(14), dp(12), dp(14));
        empty.setBackground(round(CARD, 16));
        empty.addView(text("＋  ماشین‌های دیگر را بعداً اضافه کن",
                12, MUTED, false));
        content.addView(empty);

        space(24);
        content.addView(text("فضای ذخیره‌سازی", 15, WHITE, true));
        space(10);

        LinearLayout storage = panel();
        storage.setOrientation(LinearLayout.VERTICAL);
        storage.setPadding(dp(15), dp(15), dp(15), dp(15));

        LinearLayout storageRow = new LinearLayout(this);
        storageRow.setGravity(Gravity.CENTER_VERTICAL);
        storageRow.addView(text("▤  فضای ماشین‌ها", 13, WHITE, false),
                new LinearLayout.LayoutParams(0, -2, 1));
        storageRow.addView(text("هنوز خالی", 12, MUTED, false));
        storage.addView(storageRow);

        spaceIn(storage, 14);
        View barBg = new View(this);
        barBg.setBackground(round(Color.rgb(43, 47, 54), 10));
        storage.addView(barBg, new LinearLayout.LayoutParams(-1, dp(6)));

        content.addView(storage);
    }

    View createFeaturedCard() {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setPadding(dp(18), dp(18), dp(18), dp(18));
        card.setBackground(roundGradient(
                new int[]{Color.rgb(47, 29, 20), Color.rgb(17, 20, 25)}, 22));
        card.setElevation(dp(3));

        LinearLayout status = new LinearLayout(this);
        status.setGravity(Gravity.CENTER_VERTICAL);
        TextView dot = text("●", 11, GREEN, true);
        status.addView(dot);
        status.addView(text("  نمونهٔ اولیه", 12, GREEN, true));
        card.addView(status);

        spaceIn(card, 20);
        card.addView(text("Alpine Linux", 27, WHITE, true));
        spaceIn(card, 5);
        card.addView(text("ARM64  •  64-bit", 13, MUTED, false));

        spaceIn(card, 22);

        LinearLayout specs = new LinearLayout(this);
        specs.addView(text("▣  1 GB RAM", 12, WHITE, false),
                new LinearLayout.LayoutParams(0, -2, 1));
        specs.addView(text("⚙  1 vCPU", 12, WHITE, false),
                new LinearLayout.LayoutParams(0, -2, 1));
        specs.addView(text("▤  8 GB", 12, WHITE, false),
                new LinearLayout.LayoutParams(0, -2, 1));
        card.addView(specs);

        spaceIn(card, 22);

        TextView run = text("▶    اجرای ماشین", 16, Color.BLACK, true);
        run.setGravity(Gravity.CENTER);
        run.setBackground(round(ORANGE, 15));
        run.setPadding(dp(12), dp(16), dp(12), dp(16));
        run.setOnClickListener(v -> Toast.makeText(this,
                "موتور QEMU هنوز به برنامه متصل نشده است.",
                Toast.LENGTH_LONG).show());
        card.addView(run);

        return card;
    }

    View createMachineRow(String name, String description,
                          String status, String symbol) {
        LinearLayout row = panel();
        row.setGravity(Gravity.CENTER_VERTICAL);
        row.setPadding(dp(14), dp(14), dp(14), dp(14));

        TextView icon = text(symbol, 25, ORANGE, true);
        icon.setGravity(Gravity.CENTER);
        icon.setBackground(round(Color.rgb(49, 32, 24), 14));
        row.addView(icon, params(48, 48));

        LinearLayout info = new LinearLayout(this);
        info.setOrientation(LinearLayout.VERTICAL);
        info.setPadding(dp(12), 0, 0, 0);
        info.addView(text(name, 15, WHITE, true));
        spaceIn(info, 4);
        info.addView(text(description, 11, MUTED, false));
        row.addView(info, new LinearLayout.LayoutParams(0, -2, 1));

        TextView badge = text("● " + status, 10, GREEN, true);
        row.addView(badge);

        return row;
    }

    View stat(String title, String value, String subtitle) {
        LinearLayout box = panel();
        box.setOrientation(LinearLayout.VERTICAL);
        box.setPadding(dp(12), dp(13), dp(12), dp(12));
        box.addView(text(title, 12, MUTED, false));
        spaceIn(box, 7);
        box.addView(text(value, 21, WHITE, true));
        spaceIn(box, 3);
        box.addView(text(subtitle, 10, MUTED, false));
        return box;
    }

    View createNavigation() {
        LinearLayout nav = new LinearLayout(this);
        nav.setGravity(Gravity.CENTER);
        nav.setPadding(dp(8), dp(8), dp(8), dp(8));
        nav.setBackground(round(Color.rgb(17, 19, 23), 20));

        homeTab = navItem("⌂", "خانه", true);
        machinesTab = navItem("▣", "ماشین‌ها", false);
        downloadsTab = navItem("↓", "دانلودها", false);
        settingsTab = navItem("⚙", "تنظیمات", false);

        nav.addView(homeTab, new LinearLayout.LayoutParams(0, dp(55), 1));
        nav.addView(machinesTab, new LinearLayout.LayoutParams(0, dp(55), 1));
        nav.addView(downloadsTab, new LinearLayout.LayoutParams(0, dp(55), 1));
        nav.addView(settingsTab, new LinearLayout.LayoutParams(0, dp(55), 1));

        return nav;
    }

    TextView navItem(String icon, String label, boolean selected) {
        TextView item = text(icon + "\n" + label, 12,
                selected ? ORANGE : MUTED, selected);
        item.setGravity(Gravity.CENTER);
        item.setOnClickListener(v -> {
            if (label.equals("خانه")) showHome();
            else if (label.equals("ماشین‌ها")) showMachines();
            else if (label.equals("دانلودها")) showDownloads();
            else showSettings();
        });
        return item;
    }

    void showMachines() {
        content.removeAllViews();
        pageTitle("ماشین‌های من");
        space(20);
        content.addView(createMachineRow(
                "Linux", "Alpine Linux ARM64", "خاموش", "◈"));
        space(15);
        actionButton("＋  ساخت ماشین جدید", this::showCreate);
    }

    void showCreate() {
        content.removeAllViews();
        pageTitle("ساخت ماشین مجازی");
        space(24);
        content.addView(text("انتخاب سیستم‌عامل", 18, WHITE, true));
        space(14);
        content.addView(createMachineRow(
                "Alpine Linux", "سبک و مناسب آزمایش", "ARM64", "◈"));
        space(12);
        content.addView(createMachineRow(
                "Debian", "پایدار و همه‌کاره", "ARM64", "D"));
        space(12);
        content.addView(createMachineRow(
                "Ubuntu", "محبوب و کاربردی", "ARM64", "U"));
        space(24);
        content.addView(text(
                "ساخت ماشین واقعی پس از اتصال موتور QEMU فعال می‌شود.",
                13, MUTED, false));
        space(20);
        actionButton("بازگشت به خانه", this::showHome);
    }

    void showDownloads() {
        content.removeAllViews();
        pageTitle("دانلودها");
        space(22);
        content.addView(text("سیستم‌عامل‌ها", 18, WHITE, true));
        space(12);
        content.addView(createMachineRow(
                "Alpine Linux", "تصویر ARM64", "دریافت", "◈"));
        space(12);
        content.addView(createMachineRow(
                "Debian", "تصویر ARM64", "بعداً", "D"));
        space(12);
        content.addView(createMachineRow(
                "Ubuntu", "تصویر ARM64", "بعداً", "U"));
        space(18);
        content.addView(text(
                "هنوز دانلودی شروع نشده است.",
                12, MUTED, false));
    }

    void showSettings() {
        content.removeAllViews();
        pageTitle("تنظیمات");
        space(20);
        content.addView(createMachineRow(
                "ظاهر برنامه", "تم تیره و نارنجی", "فعال", "◐"));
        space(10);
        content.addView(createMachineRow(
                "عملکرد", "مدیریت منابع ماشین مجازی", "استاندارد", "⚙"));
        space(10);
        content.addView(createMachineRow(
                "دربارهٔ PocketVM", "نسخهٔ 1.0", "اطلاعات", "i"));
        space(24);
        actionButton("بازگشت به خانه", this::showHome);
    }

    void pageTitle(String title) {
        TextView heading = text(title, 24, WHITE, true);
        content.addView(heading);
        space(6);
        content.addView(text("PocketVM  /  مدیریت ماشین مجازی",
                12, MUTED, false));
    }

    void actionButton(String label, Runnable action) {
        TextView button = text(label, 15, Color.BLACK, true);
        button.setGravity(Gravity.CENTER);
        button.setPadding(dp(12), dp(16), dp(12), dp(16));
        button.setBackground(round(ORANGE, 15));
        button.setOnClickListener(v -> action.run());
        content.addView(button);
    }

    LinearLayout panel() {
        LinearLayout view = new LinearLayout(this);
        view.setOrientation(LinearLayout.VERTICAL);
        view.setBackground(round(CARD, 17));
        return view;
    }

    TextView text(String value, float size, int color, boolean bold) {
        TextView view = new TextView(this);
        view.setText(value);
        view.setTextSize(size);
        view.setTextColor(color);
        view.setGravity(Gravity.RIGHT | Gravity.CENTER_VERTICAL);
        if (bold) view.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        return view;
    }

    GradientDrawable round(int color, int radius) {
        GradientDrawable d = new GradientDrawable();
        d.setColor(color);
        d.setCornerRadius(dp(radius));
        return d;
    }

    GradientDrawable roundGradient(int[] colors, int radius) {
        GradientDrawable d = new GradientDrawable(
                GradientDrawable.Orientation.TL_BR, colors);
        d.setCornerRadius(dp(radius));
        d.setStroke(dp(1), Color.rgb(88, 49, 29));
        return d;
    }

    LinearLayout.LayoutParams params(int width, int height) {
        return new LinearLayout.LayoutParams(dp(width), dp(height));
    }

    View gap(int width) {
        return new View(this);
    }

    void space(int height) {
        content.addView(new View(this),
                new LinearLayout.LayoutParams(1, dp(height)));
    }

    void spaceIn(LinearLayout box, int height) {
        box.addView(new View(this),
                new LinearLayout.LayoutParams(1, dp(height)));
    }

    int dp(float value) {
        return (int) (value * getResources()
                .getDisplayMetrics().density + 0.5f);
    }
}
