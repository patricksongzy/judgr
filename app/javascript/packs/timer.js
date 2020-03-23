let interval = null;

function startInterval(task, time) {
  stopInterval();
  interval = setInterval(task, time);
}

function stopInterval() {
  if (interval != null) {
    clearInterval(interval);
  }
}

document.addEventListener('turbolinks:before-cache', stopInterval());
document.addEventListener('turbolinks:before-render', stopInterval());

function updateBanner(banner, endTime) {
  if (endTime == null) {
    return;
  }

  let now = new Date().getTime() / 1000;
  let remaining = endTime - now;

  if (endTime == -1) {
    banner.textContent = I18n['contest_always_open'];
    stopInterval();
  } else if (remaining <= 0) {
    banner.textContent = I18n['contest_closed'];
    stopInterval();
  } else {
    let hours = Math.floor(remaining / 3600);
    let minutes = Math.floor(remaining / 60 % 60);
    let seconds = Math.floor(remaining % 60 % 60);

    banner.textContent = hours + " " + I18n['hours'] +  ", " + minutes + " " + I18n['minutes'] + ", " + seconds + " " + I18n['seconds'] + ".";
  }
}


document.addEventListener('turbolinks:load', () => {
  let banner = document.getElementById('time-banner');

  // reset the end time so that the interval is not stopped
  if (typeof(endTime) === "undefined") {
    let endTime;
  }

  endTime = null;
  stopInterval();

  if (banner != null) {
    endTime = banner.dataset.end;
    updateBanner(banner, endTime);
    startInterval(() => updateBanner(banner, endTime), 1000);
  }
});

