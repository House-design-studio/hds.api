let $supports = document.getElementById('supports-list');
let $UDLV1s = document.getElementById('UniformlyDistributedLoadsV1');
let $UDLV2s = document.getElementById('UniformlyDistributedLoadsV2');

function AddSupport() {
    let nextNum = GetNextNum('.support-container')

    let elem = document.createElement("div");
    elem.className = 'row align-items-center mb-3 support-container';
    elem.setAttribute('name', nextNum);
    elem.id = 'support-container-' + nextNum;
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

        <button type="button" class="btn btn-outline-danger col-4 col-lg-3" onclick="DeleteElementById('${'support-container-' + nextNum}')">
            Удалить
        </button>`;


    $supports.append(elem);

}

function AddUniformlyDistributedLoadV1() {
    let nextNum = GetNextNum('.UniformlyDistributedLoadV1');

    let elem = document.createElement("div");
    elem.className = 'UniformlyDistributedLoadV1 mb-4';
    elem.setAttribute('name', nextNum);
    elem.setAttribute('id', 'UniformlyDistributedLoadV1_' + nextNum)
    elem.innerHTML = `
                <div class="row mb-1">
                    <h6 class="col-4 col-xl-3 load_title align-middle">Нагрузка ${nextNum}</h6>
                    <button type="button" class="btn btn-outline-danger col-4 col-xl-3 buttons-margin" onclick="DeleteElementById('UniformlyDistributedLoadV1_${nextNum}')"> Удалить</button>
                </div>
                <!--Нормативная величина кг/м2-->
                <div class="row align-items-center mb-1">
                    <div class="col-12 col-lg-3">
                        <label class="form-label" for="NormativeValue" > Нормативная величина </label>
                    </div>
                    <div class="col-12 col-lg-6">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="NormativeValue" id="NormativeValue" name="NormativeValue" value="1">
                            <span class="input-group-text">кг/м<sup>2</sup></span>
                        </div>
                    </div>
                </div>

                <!--Ширина грузовой площади кг/м2-->
                <div class="row align-items-center mb-1">
                    <div class="col-12 col-lg-3">
                        <label class="form-label" for="LoadAreaWidth" > Ширина грузовой площади </label>
                    </div>
                    <div class="col-12 col-lg-6">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="LoadAreaWidth" id="LoadAreaWidth" name="LoadAreaWidth" value="1">
                            <span class="input-group-text">мм</span>
                        </div>
                    </div>
                </div>

                <!--коэффициент надёжности-->
                <div class="row align-items-center mb-1">
                    <div class="col-12 col-lg-3">
                        <label class="form-label" for="ReliabilityCoefficient" > Коэффициент надёжности </label>
                    </div>
                    <div class="col-12 col-lg-6">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="ReliabilityCoefficient" id="ReliabilityCoefficient" name="ReliabilityCoefficient" value="1">
                        </div>
                    </div>
                </div>

                <!--коэффициент понижающий-->
                <div class="row align-items-center">
                    <div class="col-12 col-lg-3">
                        <label class="form-label" for="ReducingFactor" > Понижающий коэффициент </label>
                    </div>
                    <div class="col-12 col-lg-6">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="ReducingFactor" id="ReducingFactor" name="ReducingFactor" value="1">
                        </div>
                    </div>
                </div>`;
    $UDLV1s.append(elem);
}

function AddUniformlyDistributedLoadsV2() {

}

function GetLastNum(selector) {
    let inputs = document.querySelectorAll(selector);

    let lastNum = '';
    try {
        lastNum = ((inputs[inputs.length - 1]).getAttribute('name'));
    } catch (err) {
        lastNum = '0';
    }
    let nextNum = Number(lastNum);

    return nextNum;
}

function GetNextNum(selector) {
    return GetLastNum(selector) + 1;
}

function DeleteElementById(id) {
    let element = document.getElementById(id);
    element.parentNode.removeChild(element);
}