document.getElementById('fileForm').addEventListener('submit', async function (e) {
    e.preventDefault();
  
    const current_host = window.location.hostname 
    if(current_host === 'localhost') var url = 'http://localhost:4000/api/import_csv'
    else var url = 'http://api:4000/api/import_csv'

    const fileInput = document.getElementById('file');
    var message;

    if (fileInput.files.length == 0) message = 'Por favor, selecione um arquivo.'
    else{
      const file = fileInput.files[0];
    
      const formData = new FormData();
      formData.append('file', file);
    
      try {
        const response = await fetch(url, {
          method: 'POST',
          body: formData
        });
        if (response.status == 415) {
          message = 'Formato inválido! Por favor, utilize o modelo fornecido'
        } else if(response.status == 412){
          message = 'O arquivo não possui o cabeçalho esperado. Utilize o modelo de arquivo fornecido.'
        } else if(response.status == 200){
          message = 'Arquivo recebido! Aguarde alguns instantes para que os dados sejam processados.'
        }
      } catch (error) {
        message = 'Ocorreu um erro na requisição.'
      }
    }

    const modal = document.getElementById('modal-body');
    const alert = document.getElementById('alert')
    if(!alert){
      const statusDiv = document.createElement('div');
      statusDiv.textContent = message;
      statusDiv.className = 'alert alert-warning text-center mt-2';
      statusDiv.id = 'alert'
      modal.appendChild(statusDiv);
    }else{
      alert.textContent = message;
    }
  });
  