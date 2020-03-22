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
  let now = new Date().getTime() / 1000;
  let remaining = endTime - now;

  if (remaining <= 0) {
    banner.textContent = "contest has closed.";
    stopInterval();
  } else {
    let hours = Math.floor(remaining / 3600);
    let minutes = Math.floor(remaining / 60 % 60);
    let seconds = Math.floor(remaining % 60 % 60);

    banner.textContent = hours + " hours, " + minutes + " minutes, " + seconds + " seconds.";
  }
}

document.addEventListener('turbolinks:load', () => {
  let banner = document.getElementById('time-banner');
  let endTime = 1584913884;
  
  stopInterval();
  if (banner != null) {
    updateBanner(banner, endTime);
    startInterval(() => { updateBanner(banner, endTime); }, 1000);
  }
});

