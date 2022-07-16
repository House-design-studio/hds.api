var $add = document.getElementById('addSupport');
var $supports = document.getElementById('supports-list');

function AddSupport() {
    let inputs = document.querySelectorAll('.support-container')
    
    let lastNum = '';
    try {
        lastNum = ((inputs[inputs.length - 1]).getAttribute('name'));
    } catch(err) {
        lastNum = '0';
    }
    let nextNum = Number(lastNum) + 1;

    let elem = document.createElement("div");
    elem.className = "row align-items-center mb-3 support-container";
    elem.setAttribute('name', nextNum);
    elem.innerHTML = `
        <div class="col-12 col-lg-3">
            <label class="form-label" for="support${nextNum}" > Смещение опоры ${nextNum}</label>
        </div>

        <div class="col-8 col-lg-6">
            <div class="input-group">
                <input type="text" class="form-control" aria-label="Support" id="support${nextNum}" name="Supports" value="3000">
                <span class="input-group-text">мм</span>
            </div>
        </div>

        <button type="button" class="btn btn-outline-danger col-4 col-lg-3" onclick="DeleteSupport(${nextNum})">
            Удалить
        </button>`;


    $supports.append(elem);
    
}

function DeleteSupport(number) {
    $supports.removeChild(document.getElementById('support' + number).parentElement.parentElement.parentElement);
    
}