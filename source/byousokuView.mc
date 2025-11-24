import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Math;

class byousokuView extends WatchUi.WatchFace {
    var ds = null;
    var ds2 = null;
    var ds3 = null;
    var news = null;
    var lcd = null;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        ds = WatchUi.loadResource(Rez.Fonts.ds);
        ds2 = WatchUi.loadResource(Rez.Fonts.ds2);
        ds3 = WatchUi.loadResource(Rez.Fonts.ds3);
        news = WatchUi.loadResource(Rez.Fonts.news);
        lcd = WatchUi.loadResource(Rez.Fonts.lcd);
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        var days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
        var clockTime = System.getClockTime();
        var now = Time.now();
        var info = Time.Gregorian.info(now, Time.FORMAT_SHORT);
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var dayNum = info.day_of_week;
        var dateString = Lang.format("$1$-$2$", [info.month, info.day]);
        var yearNum = info.year.toString().substring(2,4);
        var yearString = Lang.format("$1$", [yearNum]);

        var hm = View.findDrawableById("TimeLabel") as Text;
        var s = View.findDrawableById("SecondsLabel") as Text;
        var day = View.findDrawableById("DayLabel") as Text;
        var date = View.findDrawableById("DateLabel") as Text;
        var year = View.findDrawableById("YearLabel") as Text;
        var apos = View.findDrawableById("YearApostrophe") as Text;

        hm.setText(timeString);
        day.setText(days[dayNum - 1]);
        s.setText(clockTime.sec.format("%02d"));
        date.setText(dateString);
        year.setText(yearString);

        hm.setFont(ds);
        s.setFont(ds2);
        day.setFont(lcd);
        date.setFont(ds3);
        year.setFont(ds3);
        apos.setFont(news);

        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(4);
        dc.drawLine(0, 70, 160, 70);
        dc.setPenWidth(1);
        dc.drawLine(0, 138, 200, 138);

        drawCircleDisplay(dc, dayNum);
        drawCornerRadii(dc);
    }

    function drawCircleDisplay(dc, currentDay) {
        var centerX = 144;
        var centerY = 32;
        var radius = 29;
        
        // Draw outer circle
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawCircle(centerX, centerY, radius);
        
        // Draw inner segmented sections (like G-Shock)
        var innerRadius = radius - 8;
        dc.setPenWidth(1);
        
        // Draw 7 sections with dividing lines and fill current day
        for (var i = 0; i < 7; i++) {
            var angle1 = -90 + (i * 360.0 / 7);
            var angle2 = -90 + ((i + 1) * 360.0 / 7);
            var rad1 = Math.toRadians(angle1);
            System.println((currentDay+6)%8);
            
            // Fill current day section solid
            if (i == (currentDay + 5) % 7) {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
                var numFillLines = 20;
                for (var j = 0; j <= numFillLines; j++) {
                    var segAngle = angle1 + (j * (angle2 - angle1) / numFillLines);
                    var segRad = Math.toRadians(segAngle);
                    
                    var xInner = centerX + (innerRadius * Math.cos(segRad));
                    var yInner = centerY + (innerRadius * Math.sin(segRad));
                    var xOuter = centerX + (radius * Math.cos(segRad));
                    var yOuter = centerY + (radius * Math.sin(segRad));
                    
                    dc.setPenWidth(2);
                    dc.drawLine(xInner, yInner, xOuter, yOuter);
                }
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            }
            
            // Draw radial dividing line
            var x1 = centerX + (innerRadius * Math.cos(rad1));
            var y1 = centerY + (innerRadius * Math.sin(rad1));
            var x2 = centerX + (radius * Math.cos(rad1));
            var y2 = centerY + (radius * Math.sin(rad1));
            dc.setPenWidth(2);
            dc.drawLine(x1, y1, x2, y2);
        }
        
        // Draw inner circle
        dc.drawCircle(centerX, centerY, innerRadius);
    }

    function drawCornerRadii(dc) {
        var cornerX = 0;
        var cornerY = 52;
        var cornerSize = 8;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillRectangle(cornerX, cornerY + cornerSize, cornerSize, cornerSize);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillCircle(cornerX + cornerSize - 1, cornerY + cornerSize - 1, cornerSize);

        cornerX = 0;
        cornerY = 72;
        cornerSize = 8;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillRectangle(cornerX, cornerY, cornerSize, cornerSize);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillCircle(cornerX + cornerSize, cornerY + cornerSize, cornerSize);

        cornerX = dc.getWidth()-65;
        cornerY = 52;
        cornerSize = 8;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillRectangle(cornerX, cornerY + cornerSize, cornerSize, cornerSize);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillCircle(cornerX, cornerY+cornerSize-1, cornerSize);
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }
}