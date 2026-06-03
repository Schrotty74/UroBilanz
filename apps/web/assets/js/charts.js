(function (root) {
  function drawLineChart(canvas, days, labels) {
    const ctx = canvas.getContext("2d");
    const dpr = window.devicePixelRatio || 1;
    canvas.width = canvas.clientWidth * dpr;
    canvas.height = 260 * dpr;
    ctx.scale(dpr, dpr);
    const theme = chartTheme();
    drawAxes(ctx, canvas.clientWidth, 260, theme);
    drawSeries(ctx, days.map((day) => day.urineTotal), theme.urine, canvas.clientWidth, 260);
    drawSeries(ctx, days.map((day) => day.waterTotal), theme.water, canvas.clientWidth, 260);
    drawLegend(ctx, [[labels.urine, theme.urine], [labels.water, theme.water]], theme);
  }

  function drawMonthChart(canvas, rows, labels) {
    const ctx = canvas.getContext("2d");
    const dpr = window.devicePixelRatio || 1;
    canvas.width = canvas.clientWidth * dpr;
    canvas.height = 260 * dpr;
    ctx.scale(dpr, dpr);
    const width = canvas.clientWidth;
    const height = 260;
    const theme = chartTheme();
    ctx.clearRect(0, 0, width, height);
    const pad = 34;
    const max = Math.max(...rows.flatMap((row) => [row.urineTotal, row.waterTotal]), 1);
    const barW = Math.max(5, (width - pad * 2) / rows.length / 3);
    rows.forEach((row, index) => {
      const x = pad + index * ((width - pad * 2) / rows.length);
      const uH = (row.urineTotal / max) * (height - pad * 2);
      const wH = (row.waterTotal / max) * (height - pad * 2);
      ctx.fillStyle = theme.urine;
      ctx.fillRect(x, height - pad - uH, barW, uH);
      ctx.fillStyle = theme.water;
      ctx.fillRect(x + barW + 2, height - pad - wH, barW, wH);
    });
    drawLegend(ctx, [[labels.urine, theme.urine], [labels.water, theme.water]], theme);
  }

  function chartTheme() {
    const styles = getComputedStyle(document.body);
    return {
      text: styles.getPropertyValue("--ink").trim(),
      line: styles.getPropertyValue("--line").trim(),
      urine: styles.getPropertyValue("--chart-urine").trim(),
      water: styles.getPropertyValue("--chart-water").trim(),
    };
  }

  function drawAxes(ctx, width, height, theme) {
    ctx.clearRect(0, 0, width, height);
    ctx.strokeStyle = theme.line;
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(34, 14);
    ctx.lineTo(34, height - 30);
    ctx.lineTo(width - 12, height - 30);
    ctx.stroke();
  }

  function drawSeries(ctx, values, color, width, height) {
    const max = Math.max(...values, 1);
    const xStep = (width - 52) / Math.max(values.length - 1, 1);
    ctx.strokeStyle = color;
    ctx.lineWidth = 2;
    ctx.beginPath();
    values.forEach((value, index) => {
      const x = 34 + index * xStep;
      const y = height - 30 - (value / max) * (height - 52);
      if (index === 0) ctx.moveTo(x, y);
      else ctx.lineTo(x, y);
    });
    ctx.stroke();
  }

  function drawLegend(ctx, items, theme) {
    items.forEach(([label, color], index) => {
      const x = 42 + index * 90;
      ctx.fillStyle = color;
      ctx.fillRect(x, 16, 12, 12);
      ctx.fillStyle = theme.text;
      ctx.font = "12px -apple-system, BlinkMacSystemFont, Segoe UI, sans-serif";
      ctx.fillText(label, x + 18, 26);
    });
  }

  root.UroCharts = { drawLineChart, drawMonthChart };
})(window);
