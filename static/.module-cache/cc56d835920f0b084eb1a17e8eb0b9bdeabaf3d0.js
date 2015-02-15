var LoginAndRegister = React.CreateClass({
  render: function () {
    return (
      React.createElement("form", {class: "ui form"}
      )
    );
  }
});

var App = React.CreateClass({
  render: function () {
    return (React.createElement(LoginAndRegister, null));
  }
});


React.render(React.createElement(App, null));