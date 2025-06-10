package io.lippia.api.lowcode.steps;
import com.crowdar.core.VariableManager;
import io.cucumber.java.en.Given;

@Given("^define (\\w+) = generateUniqueWorkspaceName\\(\\)$")
public void define_variable(String variableName) {
    String name = "Workspace_" + java.util.UUID.randomUUID().toString().substring(0, 6);
    VariableManager.setVariable(variableName, name);
    System.out.println("Nombre generado: " + name);
}

@And("^set value (.+) of key (.+) in body (.+)$")
public void set_value_of_key_in_body(String value, String key, String filePath) {
    if (value.startsWith("${") && value.endsWith("}")) {
        String varName = value.substring(2, value.length() - 1);
        value = VariableManager.getVariable(varName)
                .orElseThrow(() -> new RuntimeException("Variable no encontrada: " + varName));
    }

    System.out.println("Set: " + key + " = " + value);

    // TODO: lógica para setear el valor en el body
}