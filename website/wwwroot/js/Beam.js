let $supports = document.getElementById('supports-list');
let $DLV1s = document.getElementById('DistributedLoadsV1');
let $DLV2s = document.getElementById('DistributedLoadsV2');

let $CLV1s = document.getElementById('ConcentratedLoadsV1');
let $CLV2s = document.getElementById('ConcentratedLoadsV2');

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

function AddDistributedLoadV1() {
    let nextNum = GetNextNum('.DistributedLoadV1');

    let elem = document.createElement("div");
    elem.className = 'DistributedLoadV1 mb-4';
    elem.setAttribute('name', nextNum);
    elem.setAttribute('id', 'DistributedLoadV1_' + nextNum)
    elem.innerHTML = `
                <div class="row mb-1">
                    <div class="col-6 col-md-5 mb-0 d-flex align-items-center">
                        <h5 class="mb-0">Нагрузка ${nextNum}</h5>
                    </div>
                    <button type="button" class="btn btn-outline-danger col-6 col-md-3 but-ms-md" onclick="DeleteElementById('DistributedLoadV1_${nextNum}')"> Удалить</button>
                </div>
                <!--смещение начала-->
                <div class="row align-items-center mb-1" id="DOffsetStart${nextNum}">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="DOffsetStart${nextNum}" > смещение начала нагрузки </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="DOffsetStart" id="DOffsetStart${nextNum}" name="DOffsetStart" value="1">
                            <span class="input-group-text">мм</span>
                        </div>
                    </div>
                </div>        
                <!--смещение конца-->
                <div class="row align-items-center mb-1" id="DOffsetEnd${nextNum}">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="DOffsetEnd${nextNum}" > смещение конца нагрузки </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="DOffsetEnd" id="DOffsetEnd${nextNum}" name="DOffsetEnd" value="1">
                            <span class="input-group-text">мм</span>
                        </div>
                    </div>
                </div>
                <!--Нормативная величина кг/м2-->
                <div class="row align-items-center mb-1">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="NormativeValue${nextNum}" > Нормативная величина </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="NormativeValue" id="NormativeValue${nextNum}" name="DNormativeValue" value="1">
                            <div class="input-group-text p-0">
                                <select class="form-select input-group-text pe-4 UMChoise" aria-label="NormativeValueumUM" name="DNormativeValueumUM" id="NormativeValueumUM${nextNum}" onchange="UpdateDistributedLoadV1('NormativeValueumUM${nextNum}', 'LoadAreaWidthContainer${nextNum}', 'ReliabilityCoefficientContainer${nextNum}')">
                                    <option value="kgm2" select>кг/м<sup>2</sup></option>
                                    <option value="kgm">кг/м</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <!--Ширина грузовой площади кг/м2-->
                <div class="row align-items-center mb-1" id="LoadAreaWidthContainer${nextNum}">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="LoadAreaWidth${nextNum}" > Ширина грузовой площади </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="LoadAreaWidth" id="LoadAreaWidth${nextNum}" name="DLoadAreaWidth" value="1">
                            <span class="input-group-text">мм</span>
                        </div>
                    </div>
                </div>

                <!--коэффициент надёжности-->
                <div class="row align-items-center mb-1" id="ReliabilityCoefficientContainer${nextNum}">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="ReliabilityCoefficient${nextNum}" > Коэффициент надёжности </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="ReliabilityCoefficient" id="ReliabilityCoefficient${nextNum}" name="DReliabilityCoefficient" value="1">
                        </div>
                    </div>
                </div>

                <!--коэффициент понижающий-->
                <div class="row align-items-center">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="ReducingFactor" > Понижающий коэффициент </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="ReducingFactor" id="ReducingFactor" name="DReducingFactor" value="1">
                        </div>
                    </div>
                </div>`;
    $DLV1s.append(elem);
}

function UpdateDistributedLoadV1(choise_id, update_id, insert_id) {
    let choiseElem = document.getElementById(choise_id);
    let choise = choiseElem.selectedIndex;

    let updateElem = document.getElementById(update_id);

    let insertElem = document.getElementById(insert_id);

    if (choise === 0) { //kgm2
        if (updateElem === null) {
            let elem = document.createElement("div");
            let id_num = choise_id.slice(18);

            elem.className = 'row align-items-center mb-1';
            elem.setAttribute('id', 'LoadAreaWidthContainer' + id_num);
            elem.innerHTML = `
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="LoadAreaWidth${id_num}" > Ширина грузовой площади </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="LoadAreaWidth" id="LoadAreaWidth${id_num}" name="DLoadAreaWidth" value="1">
                            <span class="input-group-text">мм</span>
                        </div>
                    </div>
            `;

            insertElem.parentNode.insertBefore(elem, insertElem);
        }
    } else if (choise === 1) { //kgm
        try {
            DeleteElementById(update_id)
        } catch (err) {
            console.log(err)
        }
    }
}

function AddDistributedLoadsV2() {
    let nextNum = GetNextNum('.DistributedLoadV2');

    let elem = document.createElement("div");
    elem.className = 'DistributedLoadV2 mb-4';
    elem.setAttribute('name', nextNum);
    elem.setAttribute('id', 'DistributedLoadV2_' + nextNum)
    elem.innerHTML = `
            <div id="DistributedLoadV2_${nextNum}" class="DistributedLoadV2 mb-4" >
                    
                <div class="row mb-1">
                    <div class="col-6 col-md-5 mb-0 d-flex align-items-center">
                        <h5 class="mb-0">Нагрузка ${nextNum}</h5>
                    </div>
                    <button type="button" class="btn btn-outline-danger col-6 col-md-3 but-ms-md" onclick="DeleteElementById('DistributedLoadV2_${nextNum}')"> Удалить</button>
                </div>
                <!--смещение начала-->
                <div class="row align-items-center mb-1" id="DOffsetStart${nextNum}">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="DOffsetStart${nextNum}" > смещение начала нагрузки</label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="DOffsetStart" id="DOffsetStart${nextNum}" name="DOffsetStart" value="1">
                            <span class="input-group-text">мм</span>
                        </div>
                    </div>
                </div>        
                <!--смещение конца-->
                <div class="row align-items-center mb-1" id="DOffsetEnd${nextNum}">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="DOffsetEnd${nextNum}" > смещение конца нагрузки</label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="DOffsetEnd" id="DOffsetEnd${nextNum}" name="DOffsetEnd" value="1">
                            <span class="input-group-text">мм</span>
                        </div>
                    </div>
                </div>
                
                <!--нагрузка для расчёта по первой группе предельных состояний-->
                <div class="row align-items-center mb-1">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="LoadForFirstGroup${nextNum}"> нагрузка для расчёта по первой группе </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="LoadForFirstGroup" id="LoadForFirstGroup${nextNum}" name="DLoadForFirstGroup" value="1">
                            <span class="input-group-text">кг/м</span>
                        </div>
                    </div>
                </div>

                <!--нагрузка для расчёта по второй группе предельных состояний-->
                <div class="row align-items-center mb-1">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="LoadForSecondGroup${nextNum}"> нагрузка для расчёта по второй группе </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="LoadForSecondGroup" id="LoadForSecondGroup${nextNum}" name="DLoadForSecondGroup" value="1">
                            <span class="input-group-text">кг/м</span>
                        </div>
                    </div>
                </div>
            </div>`;

    $DLV2s.append(elem);
}

function AddConcentratedLoadsV1() {
    let nextNum = GetNextNum('.ConcentratedLoadsV1');

    let elem = document.createElement("div");
    elem.className = 'ConcentratedLoadsV1 mb-4';
    elem.setAttribute('name', nextNum);
    elem.setAttribute('id', 'ConcentratedLoadsV1_' + nextNum)
    elem.innerHTML = `
                <div class="row mb-1">

                    <div class="col-6 col-md-5 mb-0 d-flex align-items-center">
                        <h5 class="mb-0">Нагрузка ${nextNum}</h5>
                    </div>

                    <button type="button" class="btn btn-outline-danger col-6 col-md-3 but-ms-md" onclick="DeleteElementById('ConcentratedLoadsV1_${nextNum}')"> Удалить</button>
                </div>

                <!--смещение-->
                <div class="row align-items-center mb-1" id="COffset${nextNum}">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="COffset${nextNum}" > смещение нагрузки </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="COffset" id="COffset${nextNum}" name="COffset" value="1">
                            <span class="input-group-text">мм</span>
                        </div>
                    </div>
                </div>        

                <!--Нормативная величина кг/м2-->
                <div class="row align-items-center mb-1">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="NormativeValue${nextNum}" > Нормативная величина </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="NormativeValue" id="NormativeValue${nextNum}" name="CNormativeValue" value="1">
                            <span class="input-group-text">кг</span>
                        </div>
                    </div>
                </div>
                <!--коэффициент надёжности-->
                <div class="row align-items-center mb-1" id="ReliabilityCoefficientContainer${nextNum}">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="ReliabilityCoefficient${nextNum}" > Коэффициент надёжности </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="ReliabilityCoefficient" id="ReliabilityCoefficient${nextNum}" name="CReliabilityCoefficient" value="1">
                        </div>
                    </div>
                </div>

                <!--коэффициент понижающий-->
                <div class="row align-items-center">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="ReducingFactor" > Понижающий коэффициент </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="ReducingFactor" id="ReducingFactor" name="CReducingFactor" value="1">
                        </div>
                    </div>
                </div>`;
    $CLV1s.append(elem);
}

function AddConcentratedLoadsV2() {
    let nextNum = GetNextNum('.ConcentratedLoadV2');

    let elem = document.createElement("div");
    elem.className = 'ConcentratedLoadV2 mb-4';
    elem.setAttribute('name', nextNum);
    elem.setAttribute('id', 'ConcentratedLoadV2_' + nextNum)
    elem.innerHTML = `
            <div id="ConcentratedLoadV2_${nextNum}" class="ConcentratedLoadV2 mb-4" >
                    
                <div class="row mb-1">
                    <div class="col-6 col-md-5 mb-0 d-flex align-items-center">
                        <h5 class="mb-0">Нагрузка ${nextNum}</h5>
                    </div>
                    <button type="button" class="btn btn-outline-danger col-6 col-md-3 but-ms-md" onclick="DeleteElementById('ConcentratedLoadV2_${nextNum}')"> Удалить</button>
                </div>
                <!--смещение-->
                <div class="row align-items-center mb-1" id="COffset${nextNum}">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="COffset${nextNum}" > смещение нагрузки </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="COffset" id="COffset${nextNum}" name="COffset" value="1">
                            <span class="input-group-text">мм</span>
                        </div>
                    </div>
                </div>    
                <!--нагрузка для расчёта по первой группе предельных состояний-->
                <div class="row align-items-center mb-1">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="СLoadForFirstGroup${nextNum}"> нагрузка для расчёта по первой группе </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="СLoadForFirstGroup" id="СLoadForFirstGroup${nextNum}" name="СLoadForFirstGroup" value="1">
                            <span class="input-group-text">кг/м</span>
                        </div>
                    </div>
                </div>

                <!--нагрузка для расчёта по второй группе предельных состояний-->
                <div class="row align-items-center mb-1">
                    <div class="col-12 col-lg-5">
                        <label class="form-label" for="СLoadForSecondGroup${nextNum}"> нагрузка для расчёта по второй группе </label>
                    </div>
                    <div class="col-12 col-lg-7">
                        <div class="input-group">
                            <input type="text" class="form-control" aria-label="СLoadForSecondGroup" id="СLoadForSecondGroup${nextNum}" name="СLoadForSecondGroup" value="1">
                            <span class="input-group-text">кг/м</span>
                        </div>
                    </div>
                </div>
            </div>`;

    $CLV2s.append(elem);
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