const toastError = async function (controller, response) {
  if (!response.ok) {
    const message = await response.text

    controller.dispatch("error", {target: document, prefix: null, detail: {message: message}})
  }
}

export default toastError
