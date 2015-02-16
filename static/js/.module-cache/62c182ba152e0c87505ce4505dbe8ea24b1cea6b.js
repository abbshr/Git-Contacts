var LoginAndRegister = React.createClass({displayName: "LoginAndRegister",
  render: function () {
    return (
      React.createElement("div", {className: "row"}, 
        React.createElement("div", {className: "col-md-5"}, 
          React.createElement("form", {className: "form-horizontal"}, 
            React.createElement("div", {className: "form-group"}, 
              React.createElement("label", {htmlFor: "inputEmail3", className: "col-sm-2 control-label"}, "Email"), 
              React.createElement("div", {className: "col-sm-7"}, 
                React.createElement("input", {type: "email", className: "form-control", placeholder: "Email", ref: "email"})
              )
            ), 
            React.createElement("div", {className: "form-group"}, 
              React.createElement("label", {htmlFor: "inputPassword3", className: "col-sm-2 control-label"}, "Password"), 
              React.createElement("div", {className: "col-sm-7"}, 
                React.createElement("input", {type: "password", className: "form-control", placeholder: "Password", ref: "password"})
              )
            ), 
            React.createElement("div", {className: "form-group"}, 
              React.createElement("div", {className: "col-sm-offset-2 col-sm-10"}, 
                React.createElement("div", {className: "row"}, 
                  React.createElement("div", {className: "col-sm-2"}, 
                    React.createElement("input", {type: "submit", className: "btn btn-default", "data-url": "/login", onClick: this.onClick, value: "登录"})
                  ), 
                  React.createElement("div", {className: "col-sm-3"}, 
                    React.createElement("input", {type: "submit", className: "btn btn-primary", "data-url": "/register", onClick: this.onClick, value: "注册试用"})
                  )
                )
              )
            )
          )
        )
      )
    );
  },
  onClick: function (e) {
    e.preventDefault();
    this.onSubmit(e.target.dataset['url']);
  },  
  onSubmit: function (url) {
    var auth = {
      "email": this.refs.email.getDOMNode().value.trim(),
      "password": this.refs.password.getDOMNode().value.trim()
    };
    this.props.onSubmit(url, auth);
  }
});

var App = React.createClass({displayName: "App",
  render: function () {
    return (
      React.createElement("div", null, 
        React.createElement(Screen, null), 
        React.createElement(LoginAndRegister, {onSubmit: this.handleSubmit})
      )
    );
  },
  handleSubmit: function (url, auth) {
    $.ajax({
      url: url,
      dataType: 'json',
      type: 'POST',
      data: auth,
      success: (function (data) {
              this.setState({ login: true });
            }).bind(this),
      error: (function (xhr, status, err) {
              this.setState({ err: err, status: status });
            }).bind(this)
    });
  },
  getInitialState: function () {
    return { 
      login: false,
      err: null,
      status: null
    };
  }
});

var Contacts = React.createClass({displayName: "Contacts",
  render: function () {
    return (
      React.createElement("div", {class: "ui "})
    );
  }
});
var Error = React.createClass({displayName: "Error",
  render: function () {
    return (
      React.createElement("div", {class: "ui floating negative message"}, 
        React.createElement("i", {class: "close icon"}), 
        React.createElement("div", {class: "header"}, 
          "this.props.status"
        ), 
        React.createElement("p", null, "this.props.err")
      )
    );
  },
  componentDidMount: function () {
    $('.message .close').on('click', function() {
      $(this).closest('.message').fadeOut();
    });
  }
});
var Screen = React.createClass({displayName: "Screen",
  render: function () {
    return (
      React.createElement("div", null, 
      React.createElement("div", {className: "row"}, 
        React.createElement("br", null), React.createElement("br", null)
      ), 
      React.createElement("div", {className: "row"}, 
        React.createElement("div", {className: "col-md-12"}, 
          React.createElement("div", {className: "jumbotron"}, 
            React.createElement("h1", null, React.createElement("i", {className: "fa fa-git-square fa-3"}), " Git Contacts"), 
            React.createElement("p", null, "在Git上搭建通讯录服务"), 
            React.createElement("p", {className: "text-right"}, 
              React.createElement("a", {className: "btn btn-primary btn-lg", href: "/inspect", role: "button"}, "了解它是如何工作的")
            )
          )
        )
      )
      )
    );
  }
});

React.render(React.createElement(App, null), document.querySelector('#main'));