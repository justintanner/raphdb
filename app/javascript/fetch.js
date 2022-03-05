function getCsrfToken() {
  const element = document.head.querySelector('meta[name="csrf-token"]')
  if (element) {
    return element.getAttribute("content")
  }
}

function fetchPost(url, data, successCallback, errorCallback) {
  const body = data;

  body["authenticity_token"] = getCsrfToken();

  const payload = {
    body: JSON.stringify(body),
    method: 'POST',
    dataType: 'json',
    credentials: "include",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": getCsrfToken()
    },
  }

  fetch(url, payload).then((response) => {
    if (response.ok) {
      return response.json();
    }
    return Promise.reject(response);
  }).then((json) => {
    successCallback(json);
  }).catch((response) => {
    if ((response.status === 200) || (response.status === 422)) {
      response.json().then((json) => {
        errorCallback(json);
      });
    } else {
      errorCallback({ errors: [response.status + ": " + response.statusText] });
    }
  });
}

export { fetchPost };